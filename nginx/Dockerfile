# Use latest nginx
FROM nginx:latest

# Remove default nginx.conf
RUN rm /etc/nginx/conf.d/default.conf

# Copy config
COPY nginx.conf /etc/nginx/conf.d/default.conf