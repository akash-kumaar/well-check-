package com.wellcheck.controller; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController public class HealthController { @GetMapping("/api/public/health") Map<String,String> health(){return Map.of("status","UP");} }

