DROP TABLE fcView
DROP TABLE fcWebpage
DROP TABLE fcUserAccount
DROP TABLE fcUser
DROP TABLE fcAccount

CREATE TABLE fcAccount
(
	PK int primary key identity(1,1),
	AccountID varchar(50),
	Name varchar(100)
)
GO

CREATE TABLE fcUser
(
	PK int primary key identity(1,1),	
	GoogleID varchar(25),
	Name varchar(50),	
	Email varchar(1000),	
)
GO

CREATE TABLE fcUserAccount
(
	PK int primary key identity(1,1),
	UserFK int foreign key references fcUser(PK),
	AccountFK int foreign key references fcAccount(PK)
)
GO

CREATE TABLE fcWebpage
(
	PK int primary key identity(1,1),
	AccountFK int foreign key references fcAccount(PK),
	Name varchar(50)
)
GO

CREATE TABLE fcView
(
	PK int primary key identity(1,1),
	PageFK int foreign key references fcWebpage(PK) NOT NULL,
	IP varchar(25),
	Latitude varchar(25),
	Longitude varchar(25),
	Country varchar(100),
	Region varchar(100),
	City varchar(100),
	Browser varchar(50),
	Desktop bit NOT NULL,
	Mobile bit NOT NULL,	
	Date datetime NOT NULL
)
GO

INSERT INTO fcUser VALUES (1,'Dilay','Çetinçay','https://scontent.xx.fbcdn.net/hphotos-xal1/v/t1.0-9/12308667_10153522065482740_6295116552898530819_n.jpg?oh=754b6ce33648b1d275314f4355300efd&oe=575AA282','dilay','1234',0)
INSERT INTO fcUser VALUES (1,'Arda','Gökmen','http://www.marcodalprato.com/wp-content/uploads/2013/09/icon-profile.png','arda','1234',0)

SELECT * FROM fcUser

INSERT INTO fcWebsite VALUES ('Markafoni','http://markafoni.com')
INSERT INTO fcWebsite VALUES ('Trendyol','http://trendyol.com')

SELECT * FROM fcWebsite

INSERT INTO fcWebpage VALUES (1,'Main')
INSERT INTO fcWebpage VALUES (1,'About')
INSERT INTO fcWebpage VALUES (1,'Detail')
INSERT INTO fcWebpage VALUES (1,'Login')
INSERT INTO fcWebpage VALUES (1,'Profile')

SELECT * FROM fcWebpage

INSERT INTO fcView VALUES (1,'','','','','','','',1,0,'',GETDATE() - 5)
INSERT INTO fcView VALUES (1,'','','','','','','',1,0,'',GETDATE() - 6)
INSERT INTO fcView VALUES (1,'','','','','','','',1,0,'',GETDATE() - 2)
INSERT INTO fcView VALUES (1,'','','','','','','',0,1,'',GETDATE())
INSERT INTO fcView VALUES (1,'','','','','','','',0,1,'',GETDATE() - 5)
INSERT INTO fcView VALUES (1,'','','','','','','',0,1,'',GETDATE() - 2)
INSERT INTO fcView VALUES (1,'','','','','','','',0,1,'',GETDATE() - 3)

INSERT INTO fcView VALUES (2,'','','','','','','',1,0,'',GETDATE() - 7)
INSERT INTO fcView VALUES (2,'','','','','','','',1,0,'',GETDATE())
INSERT INTO fcView VALUES (2,'','','','','','','',1,0,'',GETDATE() - 3)
INSERT INTO fcView VALUES (2,'','','','','','','',1,0,'',GETDATE())
INSERT INTO fcView VALUES (2,'','','','','','','',0,1,'',GETDATE())
INSERT INTO fcView VALUES (2,'','','','','','','',0,1,'',GETDATE() - 1)
INSERT INTO fcView VALUES (2,'','','','','','','',0,1,'',GETDATE() - 9)

INSERT INTO fcView VALUES (3,'','','','','','','',1,0,'',GETDATE() - 4)
INSERT INTO fcView VALUES (3,'','','','','','','',1,0,'',GETDATE() - 0)
INSERT INTO fcView VALUES (3,'','','','','','','',0,1,'',GETDATE() - 0)
INSERT INTO fcView VALUES (3,'','','','','','','',0,1,'',GETDATE())
INSERT INTO fcView VALUES (3,'','','','','','','',0,1,'',GETDATE() - 0)
INSERT INTO fcView VALUES (3,'','','','','','','',0,1,'',GETDATE() - 3)
INSERT INTO fcView VALUES (3,'','','','','','','',0,1,'',GETDATE() - 0)

INSERT INTO fcView VALUES (4,'','','','','','','',1,0,'',GETDATE() - 0)
INSERT INTO fcView VALUES (4,'','','','','','','',1,0,'',GETDATE() - 0)
INSERT INTO fcView VALUES (4,'','','','','','','',1,0,'',GETDATE() - 1)
INSERT INTO fcView VALUES (4,'','','','','','','',1,0,'',GETDATE())
INSERT INTO fcView VALUES (4,'','','','','','','',1,0,'',GETDATE() - 2)
INSERT INTO fcView VALUES (4,'','','','','','','',1,0,'',GETDATE() - 2)
INSERT INTO fcView VALUES (4,'','','','','','','',0,1,'',GETDATE() - 0)

SELECT * FROM fcView