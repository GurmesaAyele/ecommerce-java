<?php
// Test database connection for TrendHire
$servername = "localhost";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$servername", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "✅ MySQL Connection successful!<br>";
    
    // Check if trendhire database exists
    $stmt = $pdo->query("SHOW DATABASES LIKE 'trendhire'");
    if ($stmt->rowCount() > 0) {
        echo "✅ TrendHire database exists!<br>";
        
        // Connect to trendhire database
        $pdo = new PDO("mysql:host=$servername;dbname=trendhire", $username, $password);
        
        // Check tables
        $tables = ['admin', 'company', 'seeker', 'vacancy', 'application'];
        foreach ($tables as $table) {
            $stmt = $pdo->query("SHOW TABLES LIKE '$table'");
            if ($stmt->rowCount() > 0) {
                echo "✅ Table '$table' exists<br>";
            } else {
                echo "❌ Table '$table' missing<br>";
            }
        }
        
        // Check sample data
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM admin");
        $result = $stmt->fetch();
        echo "📊 Admin records: " . $result['count'] . "<br>";
        
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM company");
        $result = $stmt->fetch();
        echo "📊 Company records: " . $result['count'] . "<br>";
        
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM seeker");
        $result = $stmt->fetch();
        echo "📊 Seeker records: " . $result['count'] . "<br>";
        
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM vacancy");
        $result = $stmt->fetch();
        echo "📊 Vacancy records: " . $result['count'] . "<br>";
        
    } else {
        echo "❌ TrendHire database does not exist. Please run the SQL script first.<br>";
        echo "<br><strong>To create the database:</strong><br>";
        echo "1. Open phpMyAdmin: <a href='http://localhost/phpmyadmin' target='_blank'>http://localhost/phpmyadmin</a><br>";
        echo "2. Go to SQL tab<br>";
        echo "3. Copy and paste the contents from database/trendhire_database.sql<br>";
        echo "4. Click 'Go' to execute<br>";
    }
    
} catch(PDOException $e) {
    echo "❌ Connection failed: " . $e->getMessage() . "<br>";
    echo "<br><strong>Make sure WAMP Server is running (GREEN icon)</strong><br>";
}
?>