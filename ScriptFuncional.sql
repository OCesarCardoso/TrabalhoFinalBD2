-- ********************************** TRIGGERS **********************************

-- Impedir compras com saldo insuficiente
DELIMITER //
CREATE TRIGGER bi_trg_valida_saldo_antes_compra
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE saldo_usuario DECIMAL(10,2);
    
    SELECT saldo INTO saldo_usuario FROM usuario WHERE id_usuario = NEW.fk_id_usuario;
    
    IF saldo_usuario < NEW.valor THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Saldo insuficiente para realizar esta compra';
    END IF;
END //
DELIMITER ;


-- Limite diário de R$5.000 em compras
DELIMITER //
CREATE TRIGGER bi_trg_limite_diario_compra
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE total_dia DECIMAL(10,2);
    
    SELECT COALESCE(SUM(valor), 0) INTO total_dia
    FROM compra
    WHERE fk_id_usuario = NEW.fk_id_usuario
    AND data_compra = CURDATE();
    
    IF total_dia + NEW.valor > 5000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Limite diário de R$5.000 em compras atingido';
    END IF;
END //
DELIMITER ;


-- Atualização automática do saldo após compra
DELIMITER //
CREATE TRIGGER trg_atualiza_saldo_apos_compra
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    UPDATE usuario 
    SET saldo = saldo - NEW.valor
    WHERE id_usuario = NEW.fk_id_usuario;
END //
DELIMITER ;


-- Atualizar a quantidade de jogos do usuário
DELIMITER //
CREATE TRIGGER ai_trg_atualiza_qtd_jogos_usuario
AFTER INSERT ON biblioteca
FOR EACH ROW
BEGIN
    UPDATE usuario
    SET qtd_jogos = qtd_jogos + 1
    WHERE id_usuario = NEW.fk_id_usuario;
END //
DELIMITER ;


-- Atualizar qtd de jogos do desenvolvedor
DELIMITER //
CREATE TRIGGER ai_trg_atualiza_qtd_jogos_desenvolvedor
AFTER INSERT ON staff_jogo
FOR EACH ROW
BEGIN
    UPDATE desenvolvedor
    SET qtd_jogos_plataforma = qtd_jogos_plataforma + 1
    WHERE id_desenvolvedor = NEW.fk_id_desenvolvedor;
END //
DELIMITER ;


-- Valida o preço e a data da compra
DELIMITER //
CREATE TRIGGER bi_trg_valida_preco_compra
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE v_preco_jogo DECIMAL(10,2);
    
    -- Obter preço do jogo
    SELECT preco INTO v_preco_jogo FROM jogo WHERE id_jogo = NEW.fk_id_jogo;
    
    -- Garantir que o valor inserido corresponde ao preço do jogo
    IF NEW.valor != v_preco_jogo THEN
        SET NEW.valor = v_preco_jogo; -- Corrige automaticamente o valor
    END IF;
    
    -- Data da compra sempre atual (se não foi especificada)
    IF NEW.data_compra IS NULL THEN
        SET NEW.data_compra = CURDATE();
    END IF;
END //
DELIMITER ;


-- Atualiza a quantidade de jogos vendidos e adiciona 
DELIMITER //
CREATE TRIGGER ai_trg_pos_compra
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    -- Adicionar à biblioteca do usuário
    INSERT INTO biblioteca (fk_id_usuario, fk_id_jogo, data_aquisicao)
    VALUES (NEW.fk_id_usuario, NEW.fk_id_jogo, NEW.data_compra);
    
    -- Atualizar quantidade vendida do jogo
    UPDATE jogo SET qtd_vendida = qtd_vendida + 1 WHERE id_jogo = NEW.fk_id_jogo;
END //
DELIMITER ;


-- Verificação de idade em compras
DELIMITER //
CREATE TRIGGER bi_trg_verifica_idade_compra
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE idade_usuario INT;
    DECLARE faixa_jogo VARCHAR(10);
    
    -- idade do usuário 
    SELECT TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) INTO idade_usuario
    FROM usuario WHERE id_usuario = NEW.fk_id_usuario;
    
    -- Obtém faixa etária do jogo
    SELECT faixa_etaria INTO faixa_jogo FROM jogo WHERE id_jogo = NEW.fk_id_jogo;
    
    -- Verifica restrições de idade
    IF (faixa_jogo = '18+' AND idade_usuario < 18) OR
       (faixa_jogo = '17+' AND idade_usuario < 17) OR
       (faixa_jogo = '13+' AND idade_usuario < 13) OR
       (faixa_jogo = '10+' AND idade_usuario < 10) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Idade não permitida para comprar este jogo';
    END IF;
END //
DELIMITER ;

-- ********************************** CRUD **********************************

-- CRUD TABELA USUARIO
-- SELECT (listar todos os usuários com mais de 10 jogos e saldo superior a 100)
SELECT id_usuario, nome, nickname, qtd_jogos, saldo 
FROM usuario 
WHERE qtd_jogos > 10 AND saldo > 100 
ORDER BY qtd_jogos DESC;
-- UPDATE (atualizar status da conta e adicionar saldo para um usuário específico)
UPDATE usuario 
SET status_conta = 'INDISPONIVEL', saldo = saldo + 50.00 
WHERE id_usuario = 5;
-- DELETE (remover um usuário)
DELETE FROM usuario 
WHERE id_usuario = 8 AND qtd_jogos = 0;



-- CRUD TABELA JOGO
-- SELECT (buscar jogos por faixa etária e preço, ordenados por quantidade vendida)
SELECT id_jogo, nome, genero, preco, qtd_vendida 
FROM jogo 
WHERE faixa_etaria IN ('L', '10+') AND preco < 100.00 
ORDER BY qtd_vendida DESC;
-- UPDATE (atualizar preço após promoção)
UPDATE jogo 
SET preco = preco * 0.8 
WHERE genero = 'FPS' AND data_lancamento < '2023-12-31';
-- DELETE (remover jogo com baixas vendas)
DELETE FROM jogo 
WHERE id_jogo = 9 AND qtd_vendida < 10;



-- CRUD TABELA DESENVOLVEDOR
-- SELECT (buscar desenvolvedores com mais jogos por empresa)
SELECT empresa, COUNT(*) as total_desenvolvedores, SUM(qtd_jogos_plataforma) as total_jogos 
FROM desenvolvedor 
GROUP BY empresa 
ORDER BY total_jogos DESC;
-- UPDATE (atualizar quantidade de jogos para desenvolvedores de uma empresa específica)
UPDATE desenvolvedor 
SET qtd_jogos_plataforma = qtd_jogos_plataforma + 1 
WHERE empresa = 'Rockstar Games';
-- DELETE (remover desenvolvedor que não tem mais jogos na plataforma)
DELETE FROM desenvolvedor 
WHERE id_desenvolvedor = 12 AND qtd_jogos_plataforma = 0;



-- CRUD TABELA JOGABILIDADE
-- SELECT (consultar avaliações médias por jogo com mais de 3 avaliações)
SELECT j.nome, AVG(jb.avaliacao) as media_avaliacao, COUNT(*) as total_avaliacoes, AVG(jb.horas_jogadas) as media_horas 
FROM jogabilidade jb 
JOIN jogo j ON jb.id_jogo = j.id_jogo 
GROUP BY j.id_jogo 
HAVING COUNT(*) > 3 
ORDER BY media_avaliacao DESC;
-- UPDATE (atualizar horas jogadas e avaliação de um registro específico)
UPDATE jogabilidade 
SET horas_jogadas = horas_jogadas + 10.5, avaliacao = 9.0, data_avaliacao = CURDATE() 
WHERE id_usuario = 3 AND id_jogo = 5;
-- DELETE (remover registros de jogabilidade antigos com poucas horas)
DELETE FROM jogabilidade 
WHERE horas_jogadas < 5 AND data_avaliacao < '2023-06-01';



-- CRUD TABELA STAFF_JOGO
-- SELECT (listar projetos com maior orçamento e seus desenvolvedores)
SELECT j.nome as jogo, d.nome as desenvolvedor, d.empresa, s.orcamento, 
       DATEDIFF(s.final_desenvolvimento, s.incio_desenvolvimento) as dias_desenvolvimento 
FROM staff_jogo s 
JOIN jogo j ON s.fk_id_jogo = j.id_jogo 
JOIN desenvolvedor d ON s.fk_id_desenvolvedor = d.id_desenvolvedor 
ORDER BY s.orcamento DESC 
LIMIT 10;
-- UPDATE (atualizar orçamento e data final de desenvolvimento de um projeto)
UPDATE staff_jogo 
SET orcamento = orcamento + 500000.00, final_desenvolvimento = '2024-10-15' 
WHERE fk_id_jogo = 29;
-- DELETE (remover vínculo entre desenvolvedor e jogo)
DELETE FROM staff_jogo 
WHERE fk_id_jogo = 17 AND fk_id_desenvolvedor = 17;



-- CRUD TABELA COMPRA
-- SELECT (analisar vendas por período com detalhes do usuário e jogo)
SELECT c.data_compra, u.nickname, j.nome as jogo, j.genero, c.valor 
FROM compra c 
JOIN usuario u ON c.fk_id_usuario = u.id_usuario 
JOIN jogo j ON c.fk_id_jogo = j.id_jogo 
WHERE c.data_compra BETWEEN '2023-06-01' AND '2023-12-31' 
ORDER BY c.data_compra;
-- UPDATE (atualizar valor de compra após aplicação de desconto)
UPDATE compra 
SET valor = valor * 0.9 
WHERE data_compra >= '2024-01-01' AND valor > 200;
-- DELETE (cancelar compra recente)
DELETE FROM compra 
WHERE id_compra = 30 AND data_compra >= CURDATE() - INTERVAL 7 DAY;



-- CRUD TABELA BIBLIOTECA
-- SELECT (listar jogos na biblioteca de um usuário com detalhes)
SELECT u.nickname, j.nome as jogo, j.genero, j.faixa_etaria, b.data_aquisicao 
FROM biblioteca b 
JOIN usuario u ON b.fk_id_usuario = u.id_usuario 
JOIN jogo j ON b.fk_id_jogo = j.id_jogo 
WHERE u.id_usuario = 5 
ORDER BY b.data_aquisicao DESC;
-- UPDATE (atualizar data de aquisição após restauração de biblioteca)
UPDATE biblioteca 
SET data_aquisicao = CURDATE() 
WHERE fk_id_usuario = 10 AND data_aquisicao < '2023-01-01';
-- DELETE (remover jogo da biblioteca do usuário)
DELETE FROM biblioteca 
WHERE fk_id_usuario = 15 AND fk_id_jogo = 22;

-- ********************************** STORED PROCEDURES ********************************** 

-- Adicionar saldo à conta de um usuário
DELIMITER //
CREATE PROCEDURE adicionar_saldo(
    IN p_id_usuario INT,
    IN p_valor DECIMAL(10,2))
BEGIN
    IF p_valor <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor deve ser positivo';
    END IF;
    
    UPDATE usuario SET saldo = saldo + p_valor WHERE id_usuario = p_id_usuario;
END //
DELIMITER ;


-- Aplicar Desconto em Jogos Antigos
DELIMITER //
CREATE PROCEDURE aplicar_desconto_jogos_antigos(
    IN p_anos_limite INT, 
    IN p_percentual_desconto DECIMAL(5,2))
BEGIN
    DECLARE v_data_limite DATE;
    SET v_data_limite = DATE_SUB(CURDATE(), INTERVAL p_anos_limite YEAR);
    
    UPDATE jogo
    SET preco = ROUND(preco * (1 - p_percentual_desconto/100), 2)
    WHERE data_lancamento < v_data_limite
    AND preco > 0;
    
    SELECT CONCAT(ROW_COUNT(), ' jogos tiveram desconto aplicado') as resultado;
END //
DELIMITER ;


-- Transferência de Saldo entre Usuários
DELIMITER //
CREATE PROCEDURE transferir_saldo(
    IN p_id_remetente INT,
    IN p_id_destinatario INT,
    IN p_valor DECIMAL(10,2))
BEGIN
    DECLARE v_saldo_remetente DECIMAL(10,2);
    
    -- Verificar se valor é positivo
    IF p_valor <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor deve ser positivo';
    END IF;
    
    -- Obter saldo do remetente
    SELECT saldo INTO v_saldo_remetente 
    FROM usuario 
    WHERE id_usuario = p_id_remetente;
    
    -- Verificar saldo suficiente
    IF v_saldo_remetente < p_valor THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
    END IF;
    
    -- Executar transferência
    START TRANSACTION;
    
    UPDATE usuario SET saldo = saldo - p_valor WHERE id_usuario = p_id_remetente;
    UPDATE usuario SET saldo = saldo + p_valor WHERE id_usuario = p_id_destinatario;
    
    COMMIT;
    
    SELECT 'Transferência realizada com sucesso' as resultado;
END //
DELIMITER ;


-- Top 10 jogos mais vendidos
DELIMITER $$
CREATE PROCEDURE top10_jogos_mais_vendidos()
BEGIN
    SELECT 
        j.nome,
        COUNT(*) AS quantidade_vendas
    FROM itens_compra ic
    JOIN jogos j ON j.id = ic.id_jogo
    GROUP BY j.id
    ORDER BY quantidade_vendas DESC
    LIMIT 10;
END $$
DELIMITER ;

-- ********************************** FUNCTIONS **********************************  

-- TIMESTAMPDIFF : É uma calculadora de intervalos de tempo 
-- COALESCE : É um substituto de valores NULL, retornando o primeiro valor não-nulo 

-- Function para aplicar desconto de 20% no Período de 25 a 30 de Dezembro
DELIMITER //
CREATE FUNCTION fn_desconto_natal(preco_original DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE preco_final DECIMAL(10,2);
    
    IF MONTH(CURDATE()) = 12 AND DAY(CURDATE()) BETWEEN 25 AND 30 THEN
        SET preco_final = preco_original * 0.80;
    ELSE
        SET preco_final = preco_original;
    END IF;
    
    RETURN preco_final;
END //
DELIMITER ;


-- Function para calcular tempo total jogado
DELIMITER //
CREATE FUNCTION fn_tempo_total_jogado(p_id_usuario INT) 
RETURNS FLOAT
READS SQL DATA
BEGIN
    DECLARE total_horas FLOAT;
    
    SELECT COALESCE(SUM(horas_jogadas), 0) INTO total_horas
    FROM jogabilidade
    WHERE id_usuario = p_id_usuario;
    
    RETURN total_horas;
END //
DELIMITER ;


-- Function para verificar se o usuário possui um jogo especifico
DELIMITER //
CREATE FUNCTION fn_usuario_possui_jogo(p_id_usuario INT, p_id_jogo INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE possui_jogo BOOLEAN;
    
    SELECT COUNT(*) > 0 INTO possui_jogo
    FROM biblioteca
    WHERE fk_id_usuario = p_id_usuario AND fk_id_jogo = p_id_jogo;
    
    RETURN possui_jogo;
END //
DELIMITER ;

-- Uso das functions:

-- Aplicar desconto natalino:
SELECT fn_desconto_natal(100.00) AS preco_com_desconto;

-- Ver tempo total jogado:
SELECT fn_tempo_total_jogado(1) AS horas_totais_jogadas;

-- Verificar se usuário possui jogo, retorna TRUE (1) ou FALSE (0):
SELECT fn_usuario_possui_jogo(1, 5) AS possui_jogo;

-- ********************************** VIEWS **********************************

-- VIEW da biblioteca do usuário com detalhes completos
CREATE OR REPLACE VIEW vw_minha_biblioteca AS
SELECT DISTINCT
    u.id_usuario,
    u.nickname,
    j.id_jogo,
    j.nome AS nome_jogo,
    j.genero,
    j.faixa_etaria,
    j.tipo AS modo_jogo,
    j.tempo_medio_jogo,
    b.data_aquisicao,
    COALESCE(jb.horas_jogadas, 0) AS horas_jogadas,
    COALESCE(jb.avaliacao, 0) AS minha_avaliacao,
    jb.data_avaliacao
FROM 
    biblioteca b
JOIN 
    usuario u ON b.fk_id_usuario = u.id_usuario
JOIN 
    jogo j ON b.fk_id_jogo = j.id_jogo
LEFT JOIN 
    jogabilidade jb ON jb.id_usuario = u.id_usuario AND jb.id_jogo = j.id_jogo
ORDER BY
    b.data_aquisicao DESC;


-- Exemplo de uso
-- SELECT * FROM vw_minha_biblioteca 
-- WHERE id_usuario = 1;

-- VIEW histórico de compras do usuário com detalhes
CREATE VIEW vw_historico_compras AS
SELECT 
    u.id_usuario,
    u.nickname,
    c.id_compra,
    c.data_compra,
    j.nome AS jogo_adquirido,
    j.genero,
    c.valor AS valor_pago,
    j.preco AS preco_atual,
    (j.preco - c.valor) AS diferenca_preco,
    CASE 
        WHEN c.valor = 0 THEN 'Gratuito'
        WHEN c.valor < j.preco THEN 'Promoção'
        ELSE 'Preço normal'
    END AS tipo_compra
FROM 
    compra c
JOIN 
    usuario u ON c.fk_id_usuario = u.id_usuario
JOIN 
    jogo j ON c.fk_id_jogo = j.id_jogo
ORDER BY 
    u.id_usuario, c.data_compra DESC;


-- Exemplo de uso
-- SELECT * FROM vw_historico_compras 
-- WHERE id_usuario = 1;

-- View de jogos mais populares
CREATE VIEW vw_jogos_populares AS
SELECT 
    j.id_jogo,
    j.nome,
    j.genero,
    j.preco,
    j.qtd_vendida,
    ROUND(AVG(ja.avaliacao), 1) AS media_avaliacao,
    COUNT(DISTINCT ja.id_usuario) AS total_avaliadores
FROM jogo j
LEFT JOIN jogabilidade ja ON j.id_jogo = ja.id_jogo
GROUP BY j.id_jogo, j.nome, j.genero, j.preco, j.qtd_vendida
ORDER BY j.qtd_vendida DESC, media_avaliacao DESC;


-- View de jogos por gênero
CREATE VIEW vw_jogos_por_genero AS
SELECT 
    genero,
    COUNT(*) AS quantidade_jogos,
    SUM(qtd_vendida) AS total_vendas,
    ROUND(AVG(preco), 2) AS preco_medio,
    ROUND(SUM(qtd_vendida * preco), 2) AS receita_total
FROM jogo
GROUP BY genero
ORDER BY receita_total DESC;


-- View de jogos por faixa etária
CREATE VIEW vw_jogos_por_faixa_etaria AS
SELECT 
    faixa_etaria,
    COUNT(*) AS quantidade_jogos,
    SUM(qtd_vendida) AS total_vendas,
    ROUND(AVG(preco), 2) AS preco_medio,
    ROUND(SUM(qtd_vendida * preco), 2) AS receita_total
FROM jogo
GROUP BY faixa_etaria
ORDER BY 
    CASE faixa_etaria
        WHEN 'L' THEN 1
        WHEN '10+' THEN 2
        WHEN '13+' THEN 3
        WHEN '17+' THEN 4
        WHEN '18+' THEN 5
        ELSE 6
    END;

-- ********************************** USERS E ROLES ********************************** 

-- criação dos papéis
CREATE ROLE 'revisor';
CREATE ROLE 'manutentor'; 

-- criação dos usuários 
CREATE USER 'cesar'@'localhost' IDENTIFIED BY '1234'; 
CREATE USER 'lucas_rodrigues'@'localhost' IDENTIFIED BY 'abcd'; 

-- atribui os papeis
GRANT revisor TO 'lucas_rodrigues'@'localhost';
GRANT manutentor TO 'cesar'@'localhost';  

-- garantindo privilégios aos papéis 
GRANT SELECT, UPDATE ON steam_db.* TO revisor;
GRANT ALL PRIVILEGES ON steam_db.* TO manutentor;