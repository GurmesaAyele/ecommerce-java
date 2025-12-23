<?php
// Automated database setup for TrendHire
$servername = "localhost";
$username = "root";
$password = "";

try {
    // Connect to MySQL
    $pdo = new PDO("mysql:host=$servername", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "<h2>TrendHire Database Setup</h2>";
    echo "<p>✅ Connected to MySQL successfully!</p>";
    
    // Read the SQL file
    $sqlFile = 'database/trendhire_database.sql';
    if (file_exists($sqlFile)) {
        $sql = file_get_contents($sqlFile);
        
        // Split SQL into individual statements
        $statements = array_filter(array_map('trim', explode(';', $sql)));
        
        $successCount = 0;
        $errorCount = 0;
        
        foreach ($statements as $statement) {
            if (!empty($statement) && !preg_match('/^--/', $statement)) {
                try {
                    $pdo->exec($statement);
                    $successCount++;
                } catch (PDOException $e) {
                    if (strpos($e->getMessage(), 'already exists') === false) {
                        echo "<p style='color: orange;'>⚠️ " . htmlspecialchars($e->getMessage()) . "</p>";
                        $errorCount++;
                    }
                }
            }
        }
        
        echo "<p>✅ Executed $successCount SQL statements successfully!</p>";
        if ($errorCount > 0) {
            echo "<p style='color: orange;'>⚠️ $errorCount statements had warnings (likely already existed)</p>";
        }
        
        // Verify the setup
        $pdo = new PDO("mysql:host=$servername;dbname=trendhire", $username, $password);
        
        echo "<h3>Database Verification:</h3>";
        
        // Check tables and data
        $tables = [
            'admin' => 'Admin accounts',
            'company' => 'Company profiles', 
            'seeker' => 'Job seekers',
            'vacancy' => 'Job vacancies',
            'application' => 'Job applications'
        ];
        
        foreach ($tables as $table => $description) {
            $stmt = $pdo->query("SELECT COUNT(*) as count FROM $table");
            $result = $stmt->fetch();
            echo "<p>✅ $description: {$result['count']} records</p>";
        }
        
        echo "<h3>🎉 Database Setup Complete!</h3>";
        echo "<p><strong>You can now use these login credentials:</strong></p>";
        echo "<ul>";
        echo "<li><strong>Admin:</strong> username = admin, password = admin</li>";
        echo "<li><strong>Company:</strong> username = techcorp, password = hello</li>";
        echo "<li><strong>Job Seeker:</strong> username = johndoe, password = hello</li>";
        echo "</ul>";
        
        echo "<p><a href='build/web/index.jsp' style='background: #dc3545; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>🚀 Launch TrendHire Application</a></p>";
        
    } else {
        echo "<p style='color: red;'>❌ SQL file not found: $sqlFile</p>";
    }
    
} catch(PDOException $e) {
    echo "<p style='color: red;'>❌ Connection failed: " . $e->getMessage() . "</p>";
    echo "<p><strong>Make sure WAMP Server is running (GREEN icon)</strong></p>";
}
?>

<style>
body { font-family: Arial, sans-serif; margin: 20px; }
h2 { color: #dc3545; }
h3 { color: #28a745; }
p { margin: 10px 0; }
ul { margin: 10px 0; }
</style>