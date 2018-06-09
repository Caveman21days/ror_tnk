# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# role-based syntax
# ==================

role :app, %w{deployer@206.189.110.8}
role :web, %w{deployer@206.189.110.8}
role :db,  %w{deployer@206.189.110.8}

set :rails_env, :production
set :stage, :production

server "206.189.110.8", user: "deployer", roles: %w(web app db), primary: true


# Custom SSH Options
# ==================
# Global options
# --------------

set :ssh_options, {
  keys: %w(/home/kirill/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 4321
}