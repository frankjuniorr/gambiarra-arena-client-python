if [ ! -f .env ]; then
  cp .env.example .env

  echo ""
  echo "⚠️  Por favor, edite o arquivo .env com suas configurações:"
  echo "   - GAMBIARRA_PIN (obrigatório)"
  echo "   - PARTICIPANT_ID (obrigatório)"
  echo "   - NICKNAME (obrigatório)"
  echo ""
  echo "Depois de editar o .env,"
  read -n1 -s -r -p "Pressione qualquer tecla para continuar..."
fi

server=$(grep GAMBIARRA_URL .env | cut -d "=" -f2 | cut -d "/" -f3)
model=$(grep MODEL .env | cut -d "=" -f2)

docker compose up -d --force-recreate
sleep 1
docker exec -it gambiarra-ollama ollama pull "$model"
docker exec -it gambiarra-client gambiarra-client
