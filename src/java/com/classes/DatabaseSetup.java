package com.classes;

import java.sql.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class DatabaseSetup {
    
    public static void main(String[] args) {
        try {
            System.out.println("=== TrendHire Database Setup ===");
            
            // Test database connection
            Connection connection = DBConnector.getCon();
            if (connection != null) {
                System.out.println("✅ Database connection successful!");
                
                // Read and execute SQL file
                String sqlContent = new String(Files.readAllBytes(Paths.get("database/trendhire_database.sql")));
                
                // Split SQL statements
                String[] statements = sqlContent.split(";");
                
                int successCount = 0;
                int errorCount = 0;
                
                for (String statement : statements) {
                    statement = statement.trim();
                    if (!statement.isEmpty() && !statement.startsWith("--")) {
                        try {
                            PreparedStatement pstmt = connection.prepareStatement(statement);
                            pstmt.execute();
                            successCount++;
                            System.out.println("✅ Executed: " + statement.substring(0, Math.min(50, statement.length())) + "...");
                        } catch (SQLException e) {
                            if (!e.getMessage().contains("already exists")) {
                                System.out.println("Warning: " + e.getMessage());
                                errorCount++;
                            }
                        }
                    }
                }
                
                System.out.println("\n=== Setup Complete ===");
                System.out.println("✅ Executed " + successCount + " statements successfully");
                if (errorCount > 0) {
                    System.out.println("Warning: " + errorCount + " statements had warnings");
                }
                
                // Verify tables
                System.out.println("\n=== Database Verification ===");
                verifyTables(connection);
                
                connection.close();
                
            } else {
                System.out.println("X Database connection failed!");
                System.out.println("Make sure WAMP Server is running and MySQL is started");
            }
            
        } catch (Exception e) {
            System.out.println("X Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void verifyTables(Connection connection) throws SQLException {
        String[] tables = {"admin", "company", "seeker", "vacancy", "application"};
        
        for (String table : tables) {
            try {
                PreparedStatement stmt = connection.prepareStatement("SELECT COUNT(*) FROM " + table);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("✅ Table '" + table + "': " + count + " records");
                }
                rs.close();
                stmt.close();
            } catch (SQLException e) {
                System.out.println("X Table '" + table + "' not found: " + e.getMessage());
            }
        }
        
        System.out.println("\n🎉 Database setup complete!");
        System.out.println("\nLogin Credentials:");
        System.out.println("Admin: username=admin, password=admin");
        System.out.println("Company: username=techcorp, password=hello");
        System.out.println("Seeker: username=johndoe, password=hello");
    }
}