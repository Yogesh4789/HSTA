package com.helpdesk.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private DBConnection() {
        // Utility class
    }

    public static Connection getConnection() throws SQLException {
        String url = getConfig("HELPDESK_DB_URL", "helpdesk.db.url");
        String username = getConfig("HELPDESK_DB_USER", "helpdesk.db.user");
        String password = getConfig("HELPDESK_DB_PASSWORD", "helpdesk.db.password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found in classpath.", e);
        }

        return DriverManager.getConnection(url, username, password);
    }

    private static String getConfig(String envKey, String systemPropertyKey) throws SQLException {
        String value = System.getenv(envKey);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(systemPropertyKey);
        }
        if (value == null || value.trim().isEmpty()) {
            throw new SQLException("Missing DB configuration: set " + envKey + " or -D" + systemPropertyKey);
        }
        return value.trim();
    }
}
