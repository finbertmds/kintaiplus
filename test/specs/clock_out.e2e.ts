import { browser } from '@wdio/globals';
import LoginPage from '../pageobjects/login.page.js';
import Utils from '../pageobjects/utils.js';
import constants from './constants.js';

describe('KintaiPlus', () => {
    it('clock_out', async () => {
        var isWeekend = await Utils.isWeekend();
        var holiday = await Utils.checkIsMyHoliday();
        var isBeforeTimeJST = await Utils.isBeforeTimeJST(18, 30);

        if (isWeekend) {
            console.log("今日は週末です");
        } else if (isBeforeTimeJST) {
            console.log("現在は18:30 JST前です");
            await Utils.sendTeamsMessageWithRetry(
                "現在は18:30 JST前です。退勤打刻はこの時間以降に実行してください。"
            );
        } else if (!holiday) {
            console.log("今日は祝日ではありません");
            await LoginPage.open()
            await LoginPage.login(constants.KTP_ID, constants.KTP_PASSWORD);
            await browser.pause(5000);
            console.log("start clock out");
            await LoginPage.clockOut();
            await browser.pause(1000);
            await Utils.sendTeamsMessageWithRetry(
                "退勤打刻が完了しました。"
            );
            await browser.pause(5000);
        } else {
            console.log("今日は休みです");
        }
    })
})

