CREATE DATABASE Twitch_Database_2201321044;

USE Twitch_Database_2201321044;

CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Channel (
    ChannelID INT AUTO_INCREMENT PRIMARY KEY,
    ChannelName VARCHAR(100) NOT NULL,
    OwnerID INT,
    CreationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerID) REFERENCES User(UserID)
);

CREATE TABLE Stream (
    StreamID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ChannelID INT,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME,
    FOREIGN KEY (ChannelID) REFERENCES Channel(ChannelID)
);

CREATE TABLE ChatMessage (
    MessageID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    StreamID INT,
    Content TEXT NOT NULL,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (StreamID) REFERENCES Stream(StreamID)
);

CREATE TABLE Subscription (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ChannelID INT,
    Level VARCHAR(50),
    StartDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Price DOUBLE,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (ChannelID) REFERENCES Channel(ChannelID)
);

CREATE TABLE Clip (
    ClipID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StreamID INT,
    CreatorID INT,
    Length INT,
    CreationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StreamID) REFERENCES Stream(StreamID),
    FOREIGN KEY (CreatorID) REFERENCES User(UserID)
);

CREATE TABLE Has_Liked (
    UserID INT,
    StreamID INT,
    PRIMARY KEY (UserID, StreamID),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (StreamID) REFERENCES Stream(StreamID)
);


DELIMITER $$

CREATE PROCEDURE AddChatMessage(IN p_UserID INT, IN p_StreamID INT, IN p_Content TEXT)
BEGIN
    INSERT INTO ChatMessage (UserID, StreamID, Content)
    VALUES (p_UserID, p_StreamID, p_Content);
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION GetMessageCount(p_StreamID INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE msg_count INT DEFAULT 0;
    SELECT COUNT(*) INTO msg_count
    FROM ChatMessage
    WHERE StreamID = p_StreamID;
    RETURN msg_count;
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER prevent_duplicate_subscription
BEFORE INSERT ON Subscription
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Subscription WHERE UserID = NEW.UserID AND ChannelID = NEW.ChannelID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User is already subscribed to this channel';
    END IF;
END $$

DELIMITER ;


INSERT INTO User (Username, Password, FirstName, LastName, Email) VALUES
('user1', 'password123', 'John', 'Doe', 'john.doe@example.com'),
('user2', 'password123', 'Jane', 'Doe', 'jane.doe@example.com'),
('user3', 'password123', 'Michael', 'Smith', 'michael.smith@example.com'),
('user4', 'password123', 'Emily', 'Johnson', 'emily.johnson@example.com'),
('user5', 'password123', 'David', 'Williams', 'david.williams@example.com'),
('user6', 'password123', 'Sarah', 'Jones', 'sarah.jones@example.com'),
('user7', 'password123', 'James', 'Brown', 'james.brown@example.com'),
('user8', 'password123', 'Mary', 'Davis', 'mary.davis@example.com'),
('user9', 'password123', 'Robert', 'Miller', 'robert.miller@example.com'),
('user10', 'password123', 'Jessica', 'Wilson', 'jessica.wilson@example.com'),
('user11', 'password123', 'William', 'Moore', 'william.moore@example.com'),
('user12', 'password123', 'Elizabeth', 'Taylor', 'elizabeth.taylor@example.com'),
('user13', 'password123', 'Daniel', 'Anderson', 'daniel.anderson@example.com'),
('user14', 'password123', 'Sophia', 'Thomas', 'sophia.thomas@example.com'),
('user15', 'password123', 'Joseph', 'Jackson', 'joseph.jackson@example.com');

INSERT INTO Channel (ChannelName, OwnerID) VALUES
('TechTalks', 1),
('GamingWorld', 2),
('MusicVibes', 3),
('Cooking101', 4),
('FitnessHub', 5),
('MovieReviews', 6),
('TravelAdventures', 7),
('DailyNews', 8),
('ScienceExplorer', 9),
('ArtLovers', 10),
('FashionTrends', 11),
('SportsUpdates', 12),
('TechNews', 13),
('ComedyTime', 14),
('HealthTips', 15);

INSERT INTO Stream (Title, ChannelID, StartDate, EndDate) VALUES
('Tech Innovations 2024', 1, '2024-01-10 10:00:00', '2024-01-10 12:00:00'),
('Top 10 Games of 2024', 2, '2024-01-15 14:00:00', '2024-01-15 16:00:00'),
('Best New Music Releases', 3, '2024-02-01 18:00:00', '2024-02-01 20:00:00'),
('Healthy Eating Tips', 4, '2024-03-05 09:00:00', '2024-03-05 11:00:00'),
('Fitness for Beginners', 5, '2024-03-10 12:00:00', '2024-03-10 14:00:00'),
('Movie Night', 6, '2024-03-12 20:00:00', '2024-03-12 22:00:00'),
('Wanderlust Travel Vlog', 7, '2024-04-01 10:00:00', '2024-04-01 12:00:00'),
('Breaking News: Global Updates', 8, '2024-04-05 14:00:00', '2024-04-05 16:00:00'),
('Exploring Mars: The Future', 9, '2024-04-10 18:00:00', '2024-04-10 20:00:00'),
('Modern Art in the City', 10, '2024-05-01 09:00:00', '2024-05-01 11:00:00'),
('Latest Fashion Trends 2024', 11, '2024-05-10 12:00:00', '2024-05-10 14:00:00'),
('Live Sports: Premier League', 12, '2024-06-01 15:00:00', '2024-06-01 17:00:00'),
('The Future of Technology', 13, '2024-06-05 11:00:00', '2024-06-05 13:00:00'),
('Stand-Up Comedy Live', 14, '2024-06-10 19:00:00', '2024-06-10 21:00:00'),
('Healthy Living: Tips & Advice', 15, '2024-07-01 09:00:00', '2024-07-01 11:00:00');

INSERT INTO ChatMessage (UserID, StreamID, Content) VALUES
(1, 1, 'This is amazing!'),
(2, 2, 'I love these games!'),
(3, 3, 'Great music recommendations!'),
(4, 4, 'Healthy eating is key!'),
(5, 5, 'I need some workout tips!'),
(6, 6, 'Love the movie reviews!'),
(7, 7, 'I’ve always wanted to travel like this!'),
(8, 8, 'This news is important!'),
(9, 9, 'Mars exploration is fascinating!'),
(10, 10, 'Modern art is so cool!'),
(11, 11, 'I love the new fashion styles!'),
(12, 12, 'The match is so exciting!'),
(13, 13, 'Tech innovations will change the world!'),
(14, 14, 'Stand-up comedy is the best!'),
(15, 15, 'I need to get healthier!');

INSERT INTO Subscription (UserID, ChannelID, Level, Price) VALUES
(1, 1, 'Premium', 9.99),
(2, 2, 'Standard', 5.99),
(3, 3, 'Premium', 9.99),
(4, 4, 'Standard', 5.99),
(5, 5, 'Basic', 2.99),
(6, 6, 'Premium', 9.99),
(7, 7, 'Basic', 2.99),
(8, 8, 'Standard', 5.99),
(9, 9, 'Premium', 9.99),
(10, 10, 'Basic', 2.99),
(11, 11, 'Standard', 5.99),
(12, 12, 'Premium', 9.99),
(13, 13, 'Standard', 5.99),
(14, 14, 'Premium', 9.99),
(15, 15, 'Basic', 2.99);

INSERT INTO Clip (Title, StreamID, CreatorID, Length) VALUES
('Clip 1', 1, 1, 60),
('Clip 2', 2, 2, 90),
('Clip 3', 3, 3, 120),
('Clip 4', 4, 4, 150),
('Clip 5', 5, 5, 180),
('Clip 6', 6, 6, 200),
('Clip 7', 7, 7, 210),
('Clip 8', 8, 8, 240),
('Clip 9', 9, 9, 270),
('Clip 10', 10, 10, 300),
('Clip 11', 11, 11, 330),
('Clip 12', 12, 12, 360),
('Clip 13', 13, 13, 390),
('Clip 14', 14, 14, 420),
('Clip 15', 15, 15, 450);

INSERT INTO Has_Liked (UserID, StreamID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);
