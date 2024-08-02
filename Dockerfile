# Use the official Rust image as the base image
FROM rust:latest

# Set an environment variable for the mdbook version
ENV MDBOOK_VERSION=0.4.37

# Install mdbook with a specific version
RUN cargo install mdbook --version ${MDBOOK_VERSION}

# Set the working directory
WORKDIR /book

# Copy your book source to the container
COPY ./src /book/src
COPY ./book.toml /book/book.toml

# Build the book
RUN mdbook build

# Expose the port for the web server
EXPOSE 3000

# Start the web server
CMD ["mdbook", "serve", "--hostname", "0.0.0.0"]