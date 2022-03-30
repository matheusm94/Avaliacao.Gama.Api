/*
	Ulife para Devs - Database Model
	Matheus Matos
	Pedro Paulo
	Rafael Vaitekaitis
*/

--INÍCIO: CRIAÇÃO DAS TABELAS E ÍNDICES
IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'Usuario')
BEGIN

	CREATE TABLE Usuario
	(
		UsuarioID INTEGER IDENTITY(1, 1),
		UsuarioNome VARCHAR(500) NOT NULL,
		Email VARCHAR(150) NOT NULL,
		CPF VARCHAR(11) NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_UsuarioID] PRIMARY KEY (UsuarioID),
		CONSTRAINT [UQ_CPF] UNIQUE (CPF)

	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'Estudante')
BEGIN
	
	CREATE TABLE Estudante
	(
		EstudanteID INTEGER IDENTITY(1, 1),
		UsuarioID INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_EstudanteID] PRIMARY KEY (EstudanteID),
		CONSTRAINT [FK_Estudante_Usuario] FOREIGN KEY (UsuarioID) REFERENCES Usuario (UsuarioID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_UsuarioID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_UsuarioID 
	ON Estudante (UsuarioID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'Docente')
BEGIN

	CREATE TABLE Docente 
	(
		DocenteID INTEGER IDENTITY(1, 1),
		UsuarioID INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_DocenteID] PRIMARY KEY (DocenteID),
		CONSTRAINT [FK_Docente_Usuario] FOREIGN KEY (UsuarioID) REFERENCES Usuario (UsuarioID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_UsuarioID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_UsuarioID 
	ON Docente (UsuarioID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'Questao')
BEGIN
	
	CREATE TABLE Questao 
	(
		QuestaoID INTEGER IDENTITY(1, 1),
		Enunciado VARCHAR(500) NOT NULL,
		CriadoPor INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_QuestaoID] PRIMARY KEY (QuestaoID),
		CONSTRAINT [FK_Questao_Docente] FOREIGN KEY (CriadoPor) REFERENCES Docente (DocenteID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_CriadoPor')
BEGIN
	CREATE NONCLUSTERED INDEX IX_CriadoPor
	ON Questao (CriadoPor)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'QuestaoAlternativa')
BEGIN

	CREATE TABLE QuestaoAlternativa 
	(
		QuestaoAlternativaID INTEGER IDENTITY(1, 1),
		QuestaoAlternativaTexto VARCHAR(500) NOT NULL,
		Correto BIT,
		QuestaoID INTEGER NOT NULL,
		CriadoPor INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_QuestaoAlternativaID] PRIMARY KEY (QuestaoAlternativaID),
		CONSTRAINT [FK_QuestaoAlternativa_Docente] FOREIGN KEY (CriadoPor) REFERENCES Docente (DocenteID),
		CONSTRAINT [FK_QuestaoAlternativa_Questao] FOREIGN KEY (QuestaoID) REFERENCES Questao (QuestaoID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_CriadoPor')
BEGIN
	CREATE NONCLUSTERED INDEX IX_CriadoPor
	ON QuestaoAlternativa (CriadoPor)
	ON FG_INDEX
END


IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_QuestaoID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_QuestaoID
	ON QuestaoAlternativa (QuestaoID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'Questionario')
BEGIN

	CREATE TABLE Questionario 
	(
		QuestionarioID INTEGER IDENTITY(1, 1),
		QuestionarioNome VARCHAR(500) NOT NULL,
		CriadoPor INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_QuestionarioID] PRIMARY KEY (QuestionarioID),	
		CONSTRAINT [FK_Questionario_Docente] FOREIGN KEY (CriadoPor) REFERENCES Docente (DocenteID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'QuestionarioQuestao')
BEGIN

	CREATE TABLE QuestionarioQuestao 
	(
		QuestionarioQuestaoID INTEGER IDENTITY(1, 1),
		QuestionarioID INT,
		QuestaoID INT,
		Sequencia SMALLINT,
		CriadoPor INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_QuestionarioQuestaoID] PRIMARY KEY (QuestionarioQuestaoID),	
		CONSTRAINT [FK_QuestionarioQuestao_Docente] FOREIGN KEY (CriadoPor) REFERENCES Docente (DocenteID),
		CONSTRAINT [FK_QuestionarioQuestao_Questao] FOREIGN KEY (QuestaoID) REFERENCES Questao (QuestaoID),
		CONSTRAINT [FK_QuestionarioQuestao_Questionario] FOREIGN KEY (QuestionarioID) REFERENCES Questionario (QuestionarioID)

	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_QuestionarioID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_QuestionarioID
	ON QuestionarioQuestao (QuestionarioID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_QuestaoID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_QuestaoID
	ON QuestionarioQuestao (QuestaoID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_QuestionarioIDQuestaoID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_QuestionarioIDQuestaoID
	ON QuestionarioQuestao (QuestionarioID,QuestaoID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'Avaliacao')
BEGIN
	
	CREATE TABLE Avaliacao 
	(
		AvaliacaoID INTEGER IDENTITY(1, 1),
		AvaliacaoNome VARCHAR(500) NOT NULL,
		DocenteID INTEGER NOT NULL,
		QuestionarioID INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_AvaliacaoID] PRIMARY KEY (AvaliacaoID),	
		CONSTRAINT [FK_Avaliacao_Docente] FOREIGN KEY (DocenteID) REFERENCES Docente (DocenteID),
		CONSTRAINT [FK_Avaliacao_Questionario] FOREIGN KEY (QuestionarioID) REFERENCES Questionario (QuestionarioID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_DocenteID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_DocenteID
	ON Avaliacao (DocenteID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_QuestionarioID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_QuestionarioID
	ON Avaliacao (QuestionarioID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'AvaliacaoEstudante')
BEGIN

	CREATE TABLE AvaliacaoEstudante 
	(
		AvaliacaoEstudanteID INTEGER IDENTITY(1, 1),
		AvaliacaoID INTEGER NOT NULL,
		EstudanteID INTEGER NOT NULL,
		DataInicio DATETIME,
		DataFim DATETIME
		CONSTRAINT [PK_AvaliacaoEstudanteID] PRIMARY KEY (AvaliacaoEstudanteID),	
		CONSTRAINT [FK_AvaliacaoEstudante_Avaliacao] FOREIGN KEY (AvaliacaoID) REFERENCES Avaliacao (AvaliacaoID),
		CONSTRAINT [FK_AvaliacaoEstudante_Estudante] FOREIGN KEY (EstudanteID) REFERENCES Estudante (EstudanteID),
		CONSTRAINT [UQ_AvaliacaoID_EstudanteID] UNIQUE (AvaliacaoID, EstudanteID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_AvaliacaoID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_AvaliacaoID
	ON AvaliacaoEstudante (AvaliacaoID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_EstudanteID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_EstudanteID
	ON AvaliacaoEstudante (EstudanteID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'AvaliacaoEstudanteResposta')
BEGIN

	CREATE TABLE AvaliacaoEstudanteResposta 
	(
		AvaliacaoEstudanteRespostaID INTEGER IDENTITY(1, 1),
		AvaliacaoEstudanteID INTEGER NOT NULL,
		QuestaoAlternativaID INTEGER NOT NULL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_AvaliacaoEstudanteRespostaID] PRIMARY KEY (AvaliacaoEstudanteRespostaID),	
		CONSTRAINT [FK_AvaliacaoEstudante_AvaliacaoEstudanteID] FOREIGN KEY (AvaliacaoEstudanteID) REFERENCES AvaliacaoEstudante (AvaliacaoEstudanteID),
		CONSTRAINT [FK_AvaliacaoEstudante_QuestaoAlternativaID] FOREIGN KEY (QuestaoAlternativaID) REFERENCES QuestaoAlternativa (QuestaoAlternativaID),
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_AvaliacaoEstudanteID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_AvaliacaoEstudanteID
	ON AvaliacaoEstudanteResposta (AvaliacaoEstudanteID)
	ON FG_INDEX
END

IF NOT EXISTS(SELECT 1 FROM SYS.TABLES (NOLOCK) WHERE Name = 'AvaliacaoResultadoEstudante')
BEGIN

	CREATE TABLE AvaliacaoResultadoEstudante 
	(
		AvaliacaoResultadoEstudanteID INTEGER IDENTITY(1, 1),
		AvaliacaoEstudanteID INTEGER NOT NULL,
		Nota DECIMAL,
		DataRegistro DATETIME NOT NULL
		CONSTRAINT [PK_AvaliacaoResultadoEstudanteID] PRIMARY KEY (AvaliacaoResultadoEstudanteID),	
		CONSTRAINT [FK_AvaliacaoResultadoEstudante_AvaliacaoEstudanteID] FOREIGN KEY (AvaliacaoEstudanteID) REFERENCES AvaliacaoEstudante (AvaliacaoEstudanteID)
	)
END

IF NOT EXISTS(SELECT 1 FROM SYS.INDEXES (NOLOCK) WHERE Name = 'IX_AvaliacaoEstudanteID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_AvaliacaoEstudanteID
	ON AvaliacaoResultadoEstudante (AvaliacaoEstudanteID)
	ON FG_INDEX
END

--FIM: CRIAÇÃO DAS TABELAS E ÍNDICES

--DROP TABLE AvaliacaoResultadoEstudante
--DROP TABLE AvaliacaoEstudanteResposta
--DROP TABLE AvaliacaoEstudante
--DROP TABLE Avaliacao
--DROP TABLE QuestionarioQuestao
--DROP TABLE Questionario
--DROP TABLE QuestaoAlternativa
--DROP TABLE Questao
--DROP TABLE Docente
--DROP TABLE Estudante
--DROP TABLE Usuario

--insert into Usuario
--values('Joao Silva', 'joaosilva@gmail.com', '1234567', getdate())

--insert into Usuario
--values('marcos marcos', 'marcos@gmail.com', '234567', getdate())

insert into Estudante
values(3, GETDATE())


insert into Questionario
values('Questionario', 1, GETDATE())