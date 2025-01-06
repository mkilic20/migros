CREATE TABLE IF NOT EXISTS scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(255) NOT NULL,
    score INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create user with the recommended authentication method
ALTER USER 'gameuser'@'%' IDENTIFIED WITH caching_sha2_password BY 'gamepass123';

-- Index for faster lookups
CREATE INDEX idx_player_id ON scores(player_id); 