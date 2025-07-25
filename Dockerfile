# Use a minimal Python base image
ARG PYTHON_VERSION=3.11.11
FROM python:${PYTHON_VERSION}-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create a user to run the app securely (optional but recommended)
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/appuser" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    appuser

# Install dependencies for building Python packages
RUN apt-get update && \
    apt-get install -y gcc g++ python3-dev git && \
    rm -rf /var/lib/apt/lists/*

USER appuser
WORKDIR /home/appuser

# Copy requirements file first to install dependencies
COPY requirements.txt .
RUN python -m pip install --user --no-cache-dir -r requirements.txt

# Copy your Python agent code (update as needed)
COPY . .

# (Optional) Download model files or run custom setup commands here
# RUN python agent.py download-files

# Start the agent (adjust the command to match your agent entry point)
CMD ["python", "agent.py", "start"]
