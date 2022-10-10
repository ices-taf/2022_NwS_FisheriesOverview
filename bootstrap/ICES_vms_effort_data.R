library(icesVMS)

vms_landings_data <- icesVMS::get_fo_landings("Norwegian Sea")
write.taf(vms_landings_data, file = "vms_landings_data.csv", quote = TRUE)


vms_effort_steft <- icesVMS::get_fo_effort("Norwegian Sea")
write.taf(vms_effort_steft, file = "vms_effort_data_NwS.csv", quote = TRUE)
