package com.wellcheck.controller;
import com.wellcheck.dto.ApiDtos.*; import com.wellcheck.service.OperationalService; import jakarta.validation.Valid; import org.springframework.security.core.Authentication; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController public class OperationsController {
 private final OperationalService ops; public OperationsController(OperationalService o){ops=o;}
 @PostMapping("/api/reports") Map<String,Object> report(Authentication a,@Valid @RequestBody ReportCreate r){return ops.createReport(a,r);}
 @GetMapping("/api/reports/my") List<Map<String,Object>> mine(Authentication a){return ops.myReports(a);}
 @GetMapping("/api/public/incidents/markers") List<Map<String,Object>> markers(){return ops.markers();}
 @GetMapping("/api/public/relief-centres") List<Map<String,Object>> centres(){return ops.centres();}
 @GetMapping("/api/public/alerts") List<Map<String,Object>> alerts(){return ops.alerts();}
 @GetMapping("/api/admin/reports") List<Map<String,Object>> reports(){return ops.adminReports();}
 @PatchMapping("/api/admin/reports/{id}/review") void review(Authentication a,@PathVariable UUID id,@Valid @RequestBody Review r){ops.reviewReport(a,id,r);}
 @GetMapping("/api/admin/incidents") List<Map<String,Object>> incidents(){return ops.incidents();}
 @PostMapping("/api/admin/incidents") Map<String,Object> incident(Authentication a,@Valid @RequestBody IncidentCreate x){return ops.createIncident(a,x);}
 @PatchMapping("/api/admin/incidents/{id}/verify") void verify(Authentication a,@PathVariable UUID id){ops.verifyIncident(a,id);}
 @GetMapping("/api/admin/rescue-teams") List<Map<String,Object>> teams(){return ops.teams();}
 @PostMapping("/api/admin/rescue-teams") Map<String,Object> team(Authentication a,@Valid @RequestBody TeamCreate x){return ops.createTeam(a,x);}
 @PostMapping("/api/admin/rescue-assignments") Map<String,Object> assign(Authentication a,@Valid @RequestBody AssignmentCreate x){return ops.assign(a,x);}
 @GetMapping("/api/admin/relief-centres") List<Map<String,Object>> adminCentres(){return ops.centres();}
 @PostMapping("/api/admin/relief-centres") Map<String,Object> centre(Authentication a,@Valid @RequestBody CentreCreate x){return ops.createCentre(a,x);}
 @GetMapping("/api/admin/alerts") List<Map<String,Object>> adminAlerts(){return ops.alerts();}
 @PostMapping("/api/admin/alerts") Map<String,Object> alert(Authentication a,@Valid @RequestBody AlertCreate x){return ops.createAlert(a,x);}
 @PatchMapping("/api/admin/alerts/{id}/publish") void publish(Authentication a,@PathVariable UUID id){ops.publishAlert(a,id);}
 @GetMapping("/api/admin/data-sources") List<Map<String,Object>> sources(){return ops.sources();}
}

