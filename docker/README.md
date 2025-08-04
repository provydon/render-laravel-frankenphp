# Docker Configuration

Files:
- `Dockerfile`: Main Docker image configuration
- `supervisord.conf`: Process management configuration
- `.env.production`: Production environment variables
- `php.ini`: PHP configuration

## Usage

```bash
# From project root
docker build -t fikets-app -f docker/Dockerfile .
docker run -p 8000:8000 fikets-app
``` 