#!/bin/sh
# Meldt gewijzigde pagina's bij IndexNow (Bing, DuckDuckGo, Yandex; Google doet niet mee).
# Gebruik: ./indexnow.sh                      -> alle pagina's uit de sitemap
#          ./indexnow.sh /en/ /en/privacy/    -> alleen deze paden
# Eerst pushen, dan pas melden: IndexNow controleert het sleutelbestand op de live site.
KEY="fefe54f7f290ad861e0a02dd29ca79b1"
HOST="mijn-travelly.nl"
if [ $# -gt 0 ]; then
  PATHS="$@"
else
  PATHS=$(grep -o '<loc>[^<]*</loc>' sitemap.xml | sed 's#<loc>https://'"$HOST"'##; s#</loc>##')
fi
URLS=$(for p in $PATHS; do printf '"https://%s%s",' "$HOST" "$p"; done | sed 's/,$//')
curl -s -o /dev/null -w "IndexNow: HTTP %{http_code} (200/202 = ontvangen)\n" \
  -X POST "https://api.indexnow.org/indexnow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"host\":\"$HOST\",\"key\":\"$KEY\",\"keyLocation\":\"https://$HOST/$KEY.txt\",\"urlList\":[$URLS]}"
