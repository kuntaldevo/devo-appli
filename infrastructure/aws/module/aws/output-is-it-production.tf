
output "production"{
#  value = var.production-account-id == var.current-account ? 1 : 0
  value = contains ( var.production-account-id, var.current-account ) ? 1 : 0
}

output "is-production"{
#  value = var.production-account-id == var.current-account
  value = contains ( var.production-account-id, var.current-account )
}

output "is-not-production"{
#  value = var.production-account-id != var.current-account}"
  value = ! contains ( var.production-account-id, var.current-account )
}

output "not-production"{
#  value = var.production-account-id != var.current-account ? 1 : 0
  value = ! contains ( var.production-account-id, var.current-account ) ? 1 : 0
}

output "is-production-str"{
#  value = var.production-account-id == var.current-account ? "true" : "false"
  value = contains ( var.production-account-id, var.current-account ) ? "true" : "false"
}

output "is-not-production-str"{
#  value = var.production-account-id != var.current-account ? "true" : "false"
  value = ! contains ( var.production-account-id, var.current-account ) ? "true" : "false"
}
