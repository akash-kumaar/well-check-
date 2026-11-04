package com.wellcheck.controller;
import com.wellcheck.dto.ApiDtos.*; import com.wellcheck.entity.*; import com.wellcheck.repository.*; import com.wellcheck.security.JwtService; import jakarta.validation.Valid; import org.springframework.http.*; import org.springframework.security.crypto.password.PasswordEncoder; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController @RequestMapping("/api/auth") public class AuthController {
 private final UserRepository users; private final RoleRepository roles; private final PasswordEncoder passwords; private final JwtService jwt;
 public AuthController(UserRepository u,RoleRepository r,PasswordEncoder p,JwtService j){users=u;roles=r;passwords=p;jwt=j;}
 @PostMapping("/register") ResponseEntity<Auth> register(@Valid @RequestBody Register in){if(users.findByEmailIgnoreCase(in.email()).isPresent())throw new IllegalArgumentException("An account with that email already exists"); UserAccount u=new UserAccount();u.email=in.email().trim().toLowerCase();u.displayName=in.displayName().trim();u.passwordHash=passwords.encode(in.password());u.roles.add(roles.findByName("CITIZEN").orElseThrow());users.save(u);return ResponseEntity.status(201).body(auth(u));}
 @PostMapping("/login") Auth login(@Valid @RequestBody Login in){var u=users.findByEmailIgnoreCase(in.email()).filter(x->x.active&&passwords.matches(in.password(),x.passwordHash)).orElseThrow(()->new IllegalArgumentException("Invalid email or password"));return auth(u);}
 @GetMapping("/me") Map<String,Object> me(org.springframework.security.core.Authentication a){var u=users.findById(UUID.fromString(a.getName())).orElseThrow();return Map.of("id",u.id,"email",u.email,"displayName",u.displayName,"roles",u.roles.stream().map(x->x.name).toList());}
 private Auth auth(UserAccount u){var rs=u.roles.stream().map(x->x.name).sorted().toList();return new Auth(jwt.issue(u.id,u.email,rs),u.displayName,rs);}
}

