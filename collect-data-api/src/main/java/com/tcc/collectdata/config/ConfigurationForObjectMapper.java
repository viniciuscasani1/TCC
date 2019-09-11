package com.tcc.collectdata.config;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JSR310Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalTimeDeserializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@Configuration
public class ConfigurationForObjectMapper {

    @Bean
    @Primary
    public ObjectMapper objectMapper() {

        @SuppressWarnings( "deprecation" )
	JSR310Module jsr310Module = new JSR310Module();

        JavaTimeModule javaTimeModule = new JavaTimeModule();
        javaTimeModule.addDeserializer( LocalDateTime.class, new LocalDateTimeDeserializer( DateTimeFormatter.ISO_DATE_TIME ) );
        javaTimeModule.addDeserializer( LocalTime.class, new LocalTimeDeserializer( DateTimeFormatter.ISO_TIME ) );

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure( DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false );
        objectMapper.configure( SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false );
        objectMapper.registerModules( jsr310Module, javaTimeModule );

        return objectMapper;
    }

}
