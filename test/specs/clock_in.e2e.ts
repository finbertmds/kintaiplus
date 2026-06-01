import { browser } from '@wdio/globals';
import LoginPage from '../pageobjects/login.page.js';
import Utils from '../pageobjects/utils.js';
import constants from './constants.js';

describe('KintaiPlus', () => {
    it('clock_in', async () => {
        var isWeekend = await Utils.isWeekend();
        var holiday = await Utils.checkIsMyHoliday();
        var pastTimeJST = await Utils.isPastTimeJST(9, 25);

        if (isWeekend) {
            console.log("今日は週末です");
        } else if (pastTimeJST) {
            console.log("現在は9:25 JSTを過ぎています");
            await Utils.sendTeamsMessageWithRetry(
                "現在は9:25 JSTを過ぎています。打刻がまだされていません。",
                true
            );
            await browser.pause(5000);
        } else if (!holiday) {
            console.log("今日は祝日ではありません");
            await LoginPage.open()
            await LoginPage.login(constants.KTP_ID, constants.KTP_PASSWORD);
            await browser.pause(5000);
            console.log("start clock in");
            await LoginPage.clockIn();
            await browser.pause(1000);
            await Utils.sendTeamsMessageWithRetry(
                "打刻が完了しました。"
            );
            await browser.pause(5000);
        } else {
            console.log("今日は休みです");
        }
    })
})

