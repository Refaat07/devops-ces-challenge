# Use a tiny Python base image
FROM python:3.11-alpine

# Set the working directory inside the container
WORKDIR /app

# Install dependencies first (better for build caching)
# We use --no-cache to avoid storing the index locally, saving space
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Copy the application code and templates
COPY . .

# Expose the port (e.g., 8080)
EXPOSE 8080

# Run the app. 0.0.0.0 is REQUIRED to allow external access
CMD ["gunicorn", "-b", "0.0.0.0:8080", "--limit-request-field_size", "16384", "--access-logfile", "-", "--error-logfile", "-", "--log-level", "debug", "--access-logformat", "%(h)s %(r)s %(s)s", "app:app"]