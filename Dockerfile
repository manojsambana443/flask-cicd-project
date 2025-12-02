# Use official lightweight Python image
FROM python:3.11-slim

# Create app directory
WORKDIR /usr/src/app

# Install system deps (if any) and python deps
COPY app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ ./

# Expose port and run with gunicorn for production
EXPOSE 3000

# Use a non-root user for better security (optional)
RUN useradd --create-home appuser
USER appuser

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:3000", "--workers", "2", "--threads", "4"]
