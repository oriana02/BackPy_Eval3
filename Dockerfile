FROM python:3.10-slim
WORKDIR /app

# Instalar dependencias del sistema requeridas para conectores nativos de bases de datos si aplica
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar requerimientos optimizando la caché de Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código fuente
COPY . .

# Exponer el puerto de Flask
EXPOSE 8082

# Crear un usuario del sistema no-root para ejecutar la app de forma segura
RUN useradd -m appuser && chown -R appuser /app
USER appuser

CMD ["python", "app.py"]