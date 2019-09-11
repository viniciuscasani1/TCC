package com.tcc.collectdata.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

@Configuration
public class ConfigurationForDataSource {

    @Value( "${datasource.url}" )
    private String url;

    @Value( "${datasource.username}" )
    private String user;

    @Value( "${datasource.password}" )
    private String password;

    @Bean
    public DataSource dataSource() {

        HikariConfig config = new HikariConfig();

        config.setJdbcUrl( url );
        config.setUsername( user );
        config.setPassword( password );

        config.setDriverClassName( "org.postgresql.Driver" );
        config.setAutoCommit( false );


        return new HikariDataSource( config );
    }

    @Bean
    public JdbcTemplate jdbcTemplate( DataSource dataSource ) {
        return new JdbcTemplate( dataSource );
    }
}