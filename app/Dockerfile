FROM public.ecr.aws/docker/library/python:3.11-slim

WORKDIR /app
COPY app.py /app/

RUN pip install --no-cache-dir flask boto3

ENV FLASK_RUN_HOST=0.0.0.0
ENV PORT=8080
EXPOSE 8080

CMD ["python", "app.py"]