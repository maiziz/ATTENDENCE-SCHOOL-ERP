enum UserRole {
  director,
  general_supervisor, // generalSupervisor
  field_supervisor, // fieldSupervisor
  head_teacher, // headTeacher
  teacher,
  economist,
}

enum AttendanceStatus { pending, present, absent, late }

enum AuthStatus {
  none,
  authorized_entry, // authorizedEntry
  justified,
  unjustified,
}

enum RequestCategory { material, maintenance, pedagogical, admin }

enum RequestStatus { sent, seen, forwarded, completed, rejected }

enum ObservationType { behavioral, academic, social }

enum ObservationVisibility { public, restricted }
