DROP USER IF EXISTS 'rooty'@'%';
CREATE USER 'rooty'@'%' IDENTIFIED WITH mysql_native_password BY 'pass';
GRANT ALL PRIVILEGES ON *.* TO 'rooty'@'%';
