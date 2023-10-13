output "hcloud_server_id" {
    description = "Id of the newly created server that can be used to attach further hcloud components"
    value = hcloud_server.server.id  
}