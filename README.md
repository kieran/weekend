# Is this weekend a long weekend?
### an excuse to play with cloudflare pages

![image](https://user-images.githubusercontent.com/3444/87882280-07872f00-c9cd-11ea-82ac-8ca4b9ac5953.png)

## Running completely locally
    nvm use
    npm i
    npm run dev

## Running locally (with wrangler / CF geolocation)
    nvm use
    npm i
    npm start

## Re-generate holiday files (every year)
    bundle install
    npm run holidays

---

If you find weird GIFs displayed for specific holidays,
please add an alternative search term in the `fixWeirdGuesses.coffee` module.