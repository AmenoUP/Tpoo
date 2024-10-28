# Start from the Elixir image
FROM elixir:1.14
 
RUN sed -i -e 's/^APT/# APT/' -e 's/^DPkg/# DPkg/' /etc/apt/apt.conf.d/docker-clean
# Install curl and other necessary packages
RUN apt-get update && \
    apt-get install -y curl gnupg
 
 
# Set the working directory
WORKDIR /app
 
# Copy the application files
COPY . .
 
# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force
 
# Install Elixir dependencies
RUN mix deps.get

# Execute the entrypoint
CMD ["mix", "phx.server"]
 