CREATE DATABASE steam;

USE steam;

-- ***************** TABELAS *****************

-- TABELA USUÁRIO
CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(50) NOT NULL, 
    email VARCHAR(30) NOT NULL,
    telefone CHAR(17),
    data_nascimento DATE NOT NULL,
    nickname VARCHAR(30) NOT NULL,
    data_cadastro DATE NOT NULL,
    status_conta ENUM('DISPONIVEL', 'INDISPONIVEL') DEFAULT 'DISPONIVEL',
    qtd_jogos INT NOT NULL,
    saldo DECIMAL(10,2) NOT NULL DEFAULT 0
);

-- TABELA JOGO
CREATE TABLE jogo (
	id_jogo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    genero VARCHAR(20) NOT NULL,
    faixa_etaria ENUM('L', '10+', '13+', '17+', '18+','EM ANÁLISE') DEFAULT 'EM ANÁLISE',
    data_lancamento DATE NOT NULL,
    tempo_medio_jogo FLOAT,
    descricao TEXT,
    preco DECIMAL(10,2),
    tipo ENUM('SINGLE PLAYER', 'MULTIPLAYER ONLINE', 'MULTIPLAYER LOCAL', 'AMBOS'),
	qtd_vendida INT DEFAULT 0
);

-- TABELA JOGABILIDADE
CREATE TABLE jogabilidade (
	id_jogabilidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    horas_jogadas FLOAT,
    avaliacao DECIMAL(2,1),
    data_avaliacao DATE,
    fk_id_jogo INT,
    fk_id_usuario INT,
    FOREIGN KEY (fk_id_jogo) REFERENCES jogo(id_jogo),
    FOREIGN KEY (fk_id_usuario) REFERENCES usuario(id_usuario)
);

-- TABELA DESENVOLVEDOR
CREATE TABLE desenvolvedor (
	id_desenvolvedor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    qtd_jogos_plataforma INT DEFAULT 0,
    area_de_desenvolvimento VARCHAR(30) NOT NULL,
    empresa VARCHAR(30) NOT NULL
);

-- TABELA JOGO_DESENVOLVEDOR
CREATE TABLE staff_jogo (
	id_staff_jogo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    incio_desenvolvimento DATE NOT NULL,
    final_desenvolvimento DATE NOT NULL,
    orcamento DECIMAL(10,2) NOT NULL,
	fk_id_jogo INT NOT NULL,
    fk_id_desenvolvedor INT NOT NULL,
    FOREIGN KEY (fk_id_jogo) REFERENCES jogo(id_jogo),
    FOREIGN KEY (fk_id_desenvolvedor) REFERENCES desenvolvedor(id_desenvolvedor)
);

-- TABELA COMPRA
CREATE TABLE compra (
	id_compra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_compra DATE NOT NULL,
    fk_id_jogo INT NOT NULL,
    fk_id_usuario INT NOT NULL,
    FOREIGN KEY (fk_id_jogo) REFERENCES jogo(id_jogo),
    FOREIGN KEY (fk_id_usuario) REFERENCES usuario(id_usuario)
);

-- TABELA BIBLIOTECA
CREATE TABLE biblioteca (
    id_biblioteca INT PRIMARY KEY AUTO_INCREMENT,
    data_aquisicao DATE NOT NULL,
    fk_id_usuario INT,
    fk_id_jogo INT,
    FOREIGN KEY (fk_id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (fk_id_jogo) REFERENCES jogo(id_jogo)
);

-- ***************** INSERTS *****************

-- INSERTS PARA TABELA USUARIO
INSERT INTO usuario (nome, email, telefone, data_nascimento, nickname, data_cadastro, status_conta, qtd_jogos, saldo) VALUES
('João Silva', 'joao.silva@email.com', '(11) 99999-1111', '1992-05-15', 'joaogamer', '2023-01-10', 'DISPONIVEL', 12, 150.50),
('Maria Oliveira', 'maria.oliveira@email.com', '(11) 99999-2222', '1995-08-22', 'mariaplay', '2023-01-15', 'DISPONIVEL', 8, 75.25),
('Pedro Santos', 'pedro.santos@email.com', '(11) 99999-3333', '1990-03-10', 'pedrogame', '2023-02-01', 'DISPONIVEL', 15, 200.00),
('Ana Costa', 'ana.costa@email.com', '(11) 99999-4444', '1998-11-05', 'anacostagames', '2023-02-15', 'INDISPONIVEL', 5, 50.00),
('Lucas Mendes', 'lucas.mendes@email.com', '(11) 99999-5555', '1994-07-20', 'lucasgamer', '2023-03-01', 'DISPONIVEL', 20, 300.75),
('Julia Ferreira', 'julia.ferreira@email.com', '(11) 99999-6666', '1997-09-12', 'juliaf', '2023-03-20', 'DISPONIVEL', 9, 120.30),
('Carlos Rodrigues', 'carlos.rodrigues@email.com', '(11) 99999-7777', '1991-01-30', 'carlosgaming', '2023-04-05', 'DISPONIVEL', 18, 250.40),
('Mariana Lima', 'mariana.lima@email.com', '(11) 99999-8888', '1996-12-25', 'marianagamer', '2023-04-18', 'INDISPONIVEL', 3, 30.00),
('Rafael Alves', 'rafael.alves@email.com', '(11) 99999-9999', '1993-06-08', 'rafaplay', '2023-05-02', 'DISPONIVEL', 14, 180.20),
('Fernanda Pereira', 'fernanda.pereira@email.com', '(11) 98888-1111', '1999-04-17', 'fefegamer', '2023-05-20', 'DISPONIVEL', 7, 90.50),
('Gabriel Souza', 'gabriel.souza@email.com', '(11) 98888-2222', '1990-10-03', 'gabiplay', '2023-06-10', 'DISPONIVEL', 22, 320.60),
('Camila Nunes', 'camila.nunes@email.com', '(11) 98888-3333', '1997-02-28', 'camilagames', '2023-06-25', 'DISPONIVEL', 11, 140.30),
('Bruno Martins', 'bruno.martins@email.com', '(11) 98888-4444', '1994-08-15', 'brunogamer', '2023-07-05', 'INDISPONIVEL', 6, 80.00),
('Isabela Castro', 'isabela.castro@email.com', '(11) 98888-5555', '1998-05-20', 'isabelaplay', '2023-07-22', 'DISPONIVEL', 9, 110.25),
('Daniel Barbosa', 'daniel.barbosa@email.com', '(11) 98888-6666', '1992-11-12', 'danigames', '2023-08-15', 'DISPONIVEL', 16, 210.40),
('Laura Vieira', 'laura.vieira@email.com', '(11) 98888-7777', '1996-07-05', 'lauragamer', '2023-09-01', 'DISPONIVEL', 13, 170.60),
('Matheus Rocha', 'matheus.rocha@email.com', '(11) 98888-8888', '1993-03-25', 'matheusplay', '2023-09-18', 'DISPONIVEL', 19, 280.30),
('Beatriz Dias', 'beatriz.dias@email.com', '(11) 98888-9999', '1997-12-10', 'biagames', '2023-10-05', 'INDISPONIVEL', 4, 45.75),
('Felipe Gomes', 'felipe.gomes@email.com', '(11) 97777-1111', '1995-02-18', 'felipegamer', '2023-10-22', 'DISPONIVEL', 10, 130.20),
('Carolina Ribeiro', 'carolina.ribeiro@email.com', '(11) 97777-2222', '1991-09-30', 'carolplay', '2023-11-08', 'DISPONIVEL', 17, 240.50),
('Leonardo Teixeira', 'leonardo.teixeira@email.com', '(11) 97777-3333', '1998-06-22', 'leogames', '2023-11-25', 'DISPONIVEL', 8, 100.00),
('Amanda Cardoso', 'amanda.cardoso@email.com', '(11) 97777-4444', '1994-01-15', 'amandagamer', '2023-12-12', 'DISPONIVEL', 12, 160.75),
('Thiago Moreira', 'thiago.moreira@email.com', '(11) 97777-5555', '1990-07-08', 'thiagoplay', '2024-01-05', 'INDISPONIVEL', 5, 60.30),
('Natália Pinto', 'natalia.pinto@email.com', '(11) 97777-6666', '1996-04-03', 'natigames', '2024-01-20', 'DISPONIVEL', 11, 145.20),
('Gustavo Lima', 'gustavo.lima@email.com', '(11) 97777-7777', '1993-10-27', 'gugagamer', '2024-02-08', 'DISPONIVEL', 20, 290.60),
('Larissa Almeida', 'larissa.almeida@email.com', '(11) 97777-8888', '1997-05-12', 'lariplay', '2024-02-25', 'DISPONIVEL', 9, 115.40),
('Rodrigo Carvalho', 'rodrigo.carvalho@email.com', '(11) 97777-9999', '1992-12-05', 'rodrigogames', '2024-03-10', 'DISPONIVEL', 15, 190.25),
('Juliana Ferreira', 'juliana.ferreira@email.com', '(11) 96666-1111', '1998-09-18', 'jugamer', '2024-03-28', 'INDISPONIVEL', 7, 85.50),
('Victor Santos', 'victor.santos@email.com', '(11) 96666-2222', '1995-04-30', 'victorplay', '2024-04-15', 'DISPONIVEL', 13, 175.00),
('Luiza Costa', 'luiza.costa@email.com', '(11) 96666-3333', '1991-08-15', 'luizagames', '2024-04-22', 'DISPONIVEL', 10, 120.80);

-- INSERTS PARA TABELA JOGO
INSERT INTO jogo (nome, genero, faixa_etaria, data_lancamento, tempo_medio_jogo, descricao, preco, tipo, qtd_vendida) VALUES
('The Last Journey', 'Aventura', '13+', '2023-01-15', 25.5, 'Uma aventura épica em um mundo pós-apocalíptico', 199.99, 'SINGLE PLAYER', 2500),
('Cosmic Warfare', 'FPS', '17+', '2023-02-10', 15.2, 'Batalha intensa no espaço sideral', 159.99, 'MULTIPLAYER ONLINE', 3200),
('Fantasy Realm', 'RPG', '13+', '2023-03-05', 50.0, 'Explore um mundo mágico cheio de criaturas', 179.99, 'AMBOS', 1800),
('Racing Champions', 'Corrida', '10+', '2023-03-20', 12.5, 'Corridas de alta velocidade em pistas variadas', 129.99, 'AMBOS', 2100),
('Zombie Survival', 'Survival Horror', '18+', '2023-04-10', 18.7, 'Sobreviva em um mundo infestado de zumbis', 149.99, 'AMBOS', 2800),
('Fifa 2024', 'Esporte', '10+', '2023-09-25', 8.5, 'Simulador realista de futebol', 249.99, 'AMBOS', 4500),
('Monster Hunter World', 'Ação/RPG', '13+', '2023-05-15', 60.0, 'Cace monstros gigantes em um mundo vasto', 189.99, 'AMBOS', 2700),
('Street Fighter VI', 'Luta', '13+', '2023-06-05', 10.0, 'Clássico jogo de luta com novos personagens', 159.99, 'AMBOS', 3100),
('Puzzle Quest', 'Puzzle', 'L', '2023-06-20', 5.0, 'Desafios de quebra-cabeça para todas as idades', 49.99, 'SINGLE PLAYER', 1500),
('Stardew Valley 2', 'Simulação', 'L', '2023-07-10', 45.0, 'Administre sua própria fazenda', 89.99, 'MULTIPLAYER ONLINE', 3800),
('Call of Duty: Modern Warfare III', 'FPS', '18+', '2023-08-01', 12.0, 'Combate militar intenso em ambientes modernos', 299.99, 'MULTIPLAYER ONLINE', 5000),
('The Sims 5', 'Simulação', '13+', '2023-08-20', 55.0, 'Simule a vida real em um mundo virtual', 199.99, 'SINGLE PLAYER', 4200),
('Legend of Dragons', 'RPG', '13+', '2023-09-10', 70.0, 'Aventura épica em um mundo de fantasia com dragões', 179.99, 'SINGLE PLAYER', 2200),
('NBA 2K24', 'Esporte', '10+', '2023-10-01', 9.0, 'Simulador de basquete realista', 249.99, 'AMBOS', 3500),
('Silent Hill: Awakening', 'Terror', '18+', '2023-10-25', 15.0, 'Horror psicológico em uma cidade amaldiçoada', 169.99, 'SINGLE PLAYER', 2100),
('Assassin\'s Creed: Vikings', 'Ação/Aventura', '17+', '2023-11-15', 40.0, 'Explore a era Viking como um assassino silencioso', 229.99, 'SINGLE PLAYER', 3900),
('Minecraft 2', 'Sandbox', '10+', '2023-12-01', 100.0, 'Construa e explore um mundo de blocos', 129.99, 'AMBOS', 6500),
('Gran Turismo 8', 'Corrida', '10+', '2023-12-20', 20.0, 'Simulador realista de corridas', 199.99, 'MULTIPLAYER ONLINE', 2800),
('Resident Evil 9', 'Survival Horror', '18+', '2024-01-15', 25.0, 'Novo capítulo da série de horror de sobrevivência', 249.99, 'SINGLE PLAYER', 3200),
('Super Mario Galaxy 3', 'Plataforma', 'L', '2024-02-01', 15.0, 'Aventuras do Mario no espaço', 299.99, 'MULTIPLAYER LOCAL', 4800),
('God of War: Ragnarok II', 'Ação/Aventura', '18+', '2024-02-20', 30.0, 'Kratos enfrenta deuses nórdicos', 299.99, 'SINGLE PLAYER', 4100),
('Horizon Forbidden West 2', 'Ação/RPG', '13+', '2024-03-10', 45.0, 'Continue a jornada de Aloy', 249.99, 'SINGLE PLAYER', 3500),
('Fortnite Chapter 4', 'Battle Royale', '13+', '2024-03-25', 0.5, 'Nova temporada do famoso battle royale', 0.00, 'MULTIPLAYER ONLINE', 10000),
('League of Legends 2', 'MOBA', '13+', '2024-04-10', 0.7, 'Sequência do popular MOBA', 0.00, 'MULTIPLAYER ONLINE', 12000),
('Red Dead Redemption 3', 'Ação/Aventura', '18+', '2024-05-01', 60.0, 'Novo capítulo no Velho Oeste', 299.99, 'AMBOS', 5500),
('The Last of Us Part III', 'Ação/Aventura', '18+', '2024-05-20', 30.0, 'Continuação da história pós-apocalíptica', 299.99, 'SINGLE PLAYER', 4700),
('Cyberpunk 2078', 'RPG', '18+', '2024-06-15', 70.0, 'Futuro distópico em uma megacidade futurista', 249.99, 'SINGLE PLAYER', 3800),
('Elden Ring II', 'RPG', '17+', '2024-07-01', 80.0, 'Novo mundo aberto fantástico', 299.99, 'AMBOS', 4200),
('GTA VI', 'Ação/Aventura', '18+', '2024-08-15', 60.0, 'Novo capítulo da famosa série de mundo aberto', 349.99, 'AMBOS', 9500),
('Valorant 2.0', 'FPS', '16+', '2024-09-01', 0.6, 'Nova versão do popular FPS tático', 0.00, 'MULTIPLAYER ONLINE', 8500);

-- INSERTS PARA TABELA DESENVOLVEDOR
INSERT INTO desenvolvedor (nome, qtd_jogos_plataforma, area_de_desenvolvimento, empresa) VALUES
('Carlos Roberto', 5, 'Programação', 'Rockstar Games'),
('Maria Santos', 3, 'Design de Níveis', 'Ubisoft'),
('João Pereira', 8, 'Arte Conceitual', 'EA Games'),
('Ana Oliveira', 2, 'Modelagem 3D', 'Activision'),
('Pedro Souza', 6, 'Programação', 'Valve'),
('Juliana Costa', 4, 'Sound Design', 'Nintendo'),
('Lucas Ferreira', 7, 'Game Design', 'Sony Interactive'),
('Camila Lima', 3, 'Animação', 'Capcom'),
('Rafael Silva', 5, 'Programação', 'Bethesda'),
('Fernanda Martins', 2, 'Narrativa', 'Square Enix'),
('Gabriel Alves', 6, 'Design de Interface', 'CD Projekt Red'),
('Mariana Rocha', 4, 'Arte 2D', 'Blizzard'),
('Bruno Santos', 5, 'Programação', 'Epic Games'),
('Larissa Moreira', 3, 'Marketing', 'FromSoftware'),
('Gustavo Lima', 7, 'Produção', 'Naughty Dog'),
('Carolina Ferreira', 4, 'Teste de Qualidade', '343 Industries'),
('Daniel Rodrigues', 6, 'Programação', 'BioWare'),
('Amanda Teixeira', 2, 'Design de Som', 'Riot Games'),
('Ricardo Gomes', 5, 'Programação', 'Bandai Namco'),
('Natália Castro', 3, 'Arte 3D', 'Konami'),
('Felipe Barbosa', 4, 'Game Design', 'Sega'),
('Isabela Nunes', 2, 'UI/UX Design', 'Supercell'),
('Eduardo Dias', 6, 'Programação', 'Respawn Entertainment'),
('Aline Cardoso', 3, 'Roteiro', 'Guerrilla Games'),
('Victor Ribeiro', 5, 'Produção Executiva', '2K Games'),
('Laura Teixeira', 4, 'Direção de Arte', 'Tencent'),
('Thiago Pinto', 7, 'Programação', 'Insomniac Games'),
('Beatriz Almeida', 3, 'Marketing Digital', 'Remedy Entertainment'),
('Rodrigo Vieira', 5, 'Direção', 'Crystal Dynamics'),
('Carla Mendes', 4, 'Animação', 'Mojang Studios');

-- INSERTS PARA TABELA JOGABILIDADE
INSERT INTO jogabilidade (horas_jogadas, avaliacao, data_avaliacao, fk_id_jogo, fk_id_usuario) VALUES
(120.5, 9.5, '2023-02-10', 1, 1),
(85.2, 8.0, '2023-03-05', 2, 2),
(200.0, 9.0, '2023-04-15', 3, 3),
(50.5, 7.5, '2023-05-01', 4, 4),
(150.0, 8.5, '2023-05-20', 5, 5),
(65.3, 9.0, '2023-06-10', 6, 6),
(180.0, 8.0, '2023-07-01', 7, 7),
(40.0, 7.0, '2023-07-15', 8, 8),
(110.5, 8.5, '2023-08-05', 9, 9),
(95.0, 9.5, '2023-08-25', 10, 10),
(70.0, 8.0, '2023-09-10', 11, 11),
(210.0, 9.0, '2023-10-01', 12, 12),
(120.0, 7.5, '2023-10-20', 13, 13),
(90.0, 8.0, '2023-11-05', 14, 14),
(150.5, 9.0, '2023-11-25', 15, 15),
(80.2, 8.5, '2023-12-10', 16, 16),
(170.0, 9.5, '2023-12-30', 17, 17),
(60.0, 7.0, '2024-01-15', 18, 18),
(130.5, 8.0, '2024-02-01', 19, 19),
(95.0, 9.0, '2024-02-20', 20, 20),
(110.0, 8.5, '2024-03-10', 21, 21),
(200.5, 9.5, '2024-03-25', 22, 22),
(75.0, 7.5, '2024-04-05', 23, 23),
(160.0, 8.0, '2024-04-20', 24, 24),
(85.5, 9.0, '2024-05-10', 25, 25),
(140.0, 8.5, '2024-05-25', 26, 26),
(100.0, 7.0, '2024-06-10', 27, 27),
(180.5, 9.0, '2024-06-25', 28, 28),
(95.0, 8.5, '2024-07-10', 29, 29),
(220.0, 9.5, '2024-07-25', 30, 30);

-- INSERTS PARA TABELA STAFF_JOGO
INSERT INTO staff_jogo (incio_desenvolvimento, final_desenvolvimento, orcamento, fk_id_jogo, fk_id_desenvolvedor) VALUES
('2021-01-10', '2023-01-01', 5000000.00, 1, 1),
('2021-03-15', '2023-02-01', 4000000.00, 2, 2),
('2021-05-20', '2023-03-01', 6000000.00, 3, 3),
('2021-07-05', '2023-03-15', 3500000.00, 4, 4),
('2021-08-15', '2023-04-01', 5500000.00, 5, 5),
('2022-01-10', '2023-09-15', 8000000.00, 6, 6),
('2021-12-01', '2023-05-01', 6500000.00, 7, 7),
('2022-02-15', '2023-06-01', 4500000.00, 8, 8),
('2022-03-20', '2023-06-15', 2000000.00, 9, 9),
('2022-04-05', '2023-07-01', 3800000.00, 10, 10),
('2022-05-15', '2023-07-15', 10000000.00, 11, 11),
('2022-06-01', '2023-08-15', 7500000.00, 12, 12),
('2022-07-10', '2023-09-01', 6000000.00, 13, 13),
('2022-08-05', '2023-09-25', 8500000.00, 14, 14),
('2022-09-15', '2023-10-15', 5500000.00, 15, 15),
('2022-10-01', '2023-11-01', 9000000.00, 16, 16),
('2022-11-10', '2023-11-25', 4500000.00, 17, 17),
('2022-12-01', '2023-12-15', 7000000.00, 18, 18),
('2023-01-15', '2024-01-10', 9500000.00, 19, 19),
('2023-02-01', '2024-01-25', 12000000.00, 20, 20),
('2023-03-10', '2024-02-15', 15000000.00, 21, 21),
('2023-04-01', '2024-03-01', 11000000.00, 22, 22),
('2023-04-15', '2024-03-20', 500000.00, 23, 23),
('2023-05-01', '2024-04-01', 600000.00, 24, 24),
('2023-06-15', '2024-04-25', 18000000.00, 25, 25),
('2023-07-01', '2024-05-15', 20000000.00, 26, 26),
('2023-08-15', '2024-06-10', 12500000.00, 27, 27),
('2023-09-01', '2024-06-25', 19000000.00, 28, 28),
('2023-10-15', '2024-08-01', 25000000.00, 29, 29),
('2023-11-01', '2024-08-20', 1000000.00, 30, 30);

-- INSERTS PARA TABELA COMPRA
INSERT INTO compra (valor, data_compra, fk_id_jogo, fk_id_usuario) VALUES
(19.99, '2023-01-20', 1, 1),
(19.99, '2023-02-15', 2, 2),
(19.99, '2023-03-10', 3, 3),
(19.99, '2023-03-25', 4, 4),
(19.99, '2023-04-15', 5, 5),
(29.99, '2023-09-30', 6, 6),
(19.99, '2023-05-20', 7, 7),
(19.99, '2023-06-10', 8, 8),
(49.99, '2023-06-25', 9, 9),
(89.99, '2023-07-15', 10, 10),
(9.99, '2023-08-05', 11, 11),
(19.99, '2023-08-25', 12, 12),
(19.99, '2023-09-15', 13, 13),
(29.99, '2023-10-05', 14, 14),
(19.99, '2023-10-30', 15, 15),
(22.99, '2023-11-20', 16, 16),
(12.99, '2023-12-05', 17, 17),
(19.99, '2023-12-25', 18, 18),
(24.99, '2024-01-20', 19, 19),
(29.99, '2024-02-05', 20, 20),
(29.99, '2024-02-25', 21, 21),
(24.99, '2024-03-15', 22, 22),
(0.00, '2024-03-30', 23, 23),
(0.00, '2024-04-15', 24, 24),
(29.99, '2024-05-05', 25, 25),
(29.99, '2024-05-25', 26, 26),
(24.99, '2024-06-20', 27, 27),
(29.99, '2024-07-05', 28, 28),
(34.99, '2024-08-20', 29, 29),
(0.00, '2024-09-05', 30, 30);

-- INSERTS PARA TABELA BIBLIOTECA
INSERT INTO biblioteca (fk_id_usuario, fk_id_jogo, data_aquisicao) VALUES
(1, 1, '2023-01-20'),
(2, 2, '2023-02-15'),
(3, 3, '2023-03-10'),
(4, 4, '2023-03-25'),
(5, 5, '2023-04-15'),
(6, 6, '2023-09-30'),
(7, 7, '2023-05-20'),
(8, 8, '2023-06-10'),
(9, 9, '2023-06-25'),
(10, 10, '2023-07-15'),
(11, 11, '2023-08-05'),
(12, 12, '2023-08-25'),
(13, 13, '2023-09-15'),
(14, 14, '2023-10-05'),
(15, 15, '2023-10-30'),
(16, 16, '2023-11-20'),
(17, 17, '2023-12-05'),
(18, 18, '2023-12-25'),
(19, 19, '2024-01-20'),
(20, 20, '2024-02-05'),
(21, 21, '2024-02-25'),
(22, 22, '2024-03-15'),
(23, 23, '2024-03-30'),
(24, 24, '2024-04-15'),
(25, 25, '2024-05-05'),
(26, 26, '2024-05-25'),
(27, 27, '2024-06-20'),
(28, 28, '2024-07-05'),
(29, 29, '2024-08-20'),
(30, 30, '2024-09-05');
