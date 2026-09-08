from google_play_scraper import Sort, reviews, app

APP_IDS = {
    "Metrobank": "ph.com.metrobank.mcc.mbonline",
    "BDO": "ph.com.bdo.retail",
    "BPI": "com.bpi.ng.app",
    "UnionBank": "com.unionbankph.online"
}

for bank_name, app_id in APP_IDS.items():
    info = app(app_id, lang='en', country='ph')
    print(f"{bank_name}: {info['reviews']} reviews")

