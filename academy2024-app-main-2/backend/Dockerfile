
# Use the official Golang image to build the Go application
FROM golang:1.23-alpine AS build

# Set the current working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to the workspace
COPY go.mod go.sum ./

# Download dependencies (go.sum and go.mod will ensure the proper versions are fetched)
RUN go mod download

# Copy the rest of the application code to the workspace
COPY . .

# Build the Go application
RUN go build -o server ./server.go

# Use a minimal base image for the final stage
FROM alpine:latest

# Set working directory for the final container
WORKDIR /app

# Copy the binary from the build stage
COPY --from=build /app/server .

# Expose port 8080 to the host
EXPOSE 8080

# Command to run the Go application
CMD ["./server"]
