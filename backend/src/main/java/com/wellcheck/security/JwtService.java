package com.wellcheck.security;
import io.jsonwebtoken.*; import io.jsonwebtoken.security.Keys; import org.springframework.beans.factory.annotation.Value; import org.springframework.stereotype.Service; import javax.crypto.SecretKey; import java.nio.charset.StandardCharsets; import java.time.*; import java.util.*;
@Service public class JwtService {
 private final SecretKey key;
 public JwtService(@Value("${wellcheck.jwt-secret}") String secret){ if(secret.length()<32) throw new IllegalArgumentException("JWT secret must be at least 32 characters"); key=Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8)); }
 public String issue(UUID id,String email,List<String> roles){ return Jwts.builder().subject(id.toString()).claim("email",email).claim("roles",roles).issuedAt(new Date()).expiration(Date.from(Instant.now().plus(Duration.ofHours(8)))).signWith(key).compact(); }
 public Claims parse(String token){ return Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload(); }
}

