package com.helpdesk.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/helpdesk_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";

    private DBConnection() {
        // Utility class
    }

    public static Connection getConnection() throws SQLException {
        String url = getConfig("HELPDESK_DB_URL", "helpdesk.db.url", DEFAULT_URL);
        String username = getConfig("HELPDESK_DB_USER", "helpdesk.db.user", DEFAULT_USER);
        String password = getConfig("HELPDESK_DB_PASSWORD", "helpdesk.db.password", DEFAULT_PASSWORD);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found in classpath.", e);
        }

        return DriverManager.getConnection(url, username, password);
    }

    private static String getConfig(String envKey, String systemPropertyKey, String defaultValue) {
        String value = System.getenv(envKey);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(systemPropertyKey);
        }
        if (value == null || value.trim().isEmpty()) {
            value = defaultValue;
        }
        return value.trim();
    }
}
