SELECT 'DROP TABLE " '|| TABLE_NAME ||' " CASCADE CONSTRAINTS;' FROM USER_tables;


CREATE TABLE member(
    id NVARCHAR2(15) PRIMARY KEY,
    pwd NVARCHAR2(16) NOT NULL,
    nickname NVARCHAR2(30) NOT NULL,
    phone NUMBER(11) NOT NULL,
    email NVARCHAR2(50) NOT NULL,
    addr NVARCHAR2(50) NOT NULL
);


























