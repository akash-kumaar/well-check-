package com.wellcheck.dto;
import jakarta.validation.constraints.*; import java.util.*;
public final class ApiDtos {
 private ApiDtos(){}
 public record Register(@Email @NotBlank String email,@Size(min=12,max=128) String password,@NotBlank @Size(max=120) String displayName){}
 public record Login(@Email @NotBlank String email,@NotBlank String password){}
 public record Auth(String token,String displayName,List<String> roles){}
 public record ReportCreate(@NotBlank @Size(max=50) String category,@NotBlank @Size(max=5000) String description,@DecimalMin("-90.0") @DecimalMax("90.0") Double latitude,@DecimalMin("-180.0") @DecimalMax("180.0") Double longitude,@Size(max=255) String locationLabel){}
 public record Review(@NotBlank String status,@Size(max=2000) String note){}
 public record IncidentCreate(@NotBlank String title,@NotBlank String category,@NotBlank String priority,Double latitude,Double longitude){}
 public record TeamCreate(@NotBlank String name,@Size(max=2000) String capabilities,Double latitude,Double longitude){}
 public record AssignmentCreate(@NotNull UUID incidentId,@NotNull UUID teamId,@Size(max=2000) String detail){}
 public record CentreCreate(@NotBlank String name,String address,String contact,@Min(0) int capacity,@Min(0) int availableBeds,Double latitude,Double longitude){}
 public record AlertCreate(@NotBlank String title,@NotBlank String body,@NotBlank String severity,String expiresAt){}
 public record AerialRequest(@NotBlank String name,String footagePath,Map<String,Object> telemetry){}
}

