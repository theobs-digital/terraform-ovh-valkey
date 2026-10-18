locals {
  # Normalize nullable lists to empty lists for dynamic blocks
  ip_restrictions = coalesce(var.ip_restrictions, [])
}
