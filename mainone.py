from google_play_scraper import Sort, reviews, app
import pandas as pd

APP_IDS = {
    "Metrobank": "ph.com.metrobank.mcc.mbonline",
    "BDO": "ph.com.bdo.retail",
    "BPI": "com.bpi.ng.app",
    "UnionBank": "com.unionbankph.online"
}

all_reviews = []
for bank_name, app_id in APP_IDS.items():
    result, continuation_token = reviews(
        app_id,
        lang='en',
        country='ph',
        sort=Sort.NEWEST,
        count=3000
    )

    print(bank_name, len(result))

    for r in result:
        r["bank"] = bank_name

    all_reviews.extend(result)

print("Total collected:", len(all_reviews))

df = pd.DataFrame(all_reviews)
df.to_csv("google_play_reviews.csv", index=False)

print(df.shape)
print(df.head())