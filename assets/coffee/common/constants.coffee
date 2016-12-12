module.exports =
    # on mobile
    #API_URL:
    # http://test.sce.pccu.edu.tw/SceAppApi
    # http://sceapi.sce.pccu.edu.tw/SceAppApi
    # dev mode (chrome)
    #API_URL: 'http://localhost:8100/SceAppApi'
    API_URL: {
        'browser': 'http://localhost:8100/SceAppApi'
        'browser_ssl': 'http://localhost:8100/SceAppApi'
        'device': 'http://sceapi.sce.pccu.edu.tw/SceAppApi'
        'device_ssl': 'http://sceapi.sce.pccu.edu.tw/SceAppApi'
        'atm': 'http://140.137.200.233/AtmWebApi'
        'creditcard': 'http://140.137.200.233/CCardWebAPI'
    }

    DEFAULT_LOCALE: 'zh-Hant'

    DEFAULT_NOTIFICATION_SETTING: 't'

    DEFAULT_CARD:
        'card':
            'number_part1': ''
            'number_part2': ''
            'number_part3': ''
            'number_part4': ''
            'expire_month': ''
            'expire_year': ''

    WEEKDAYS: ['一', '二', '三', '四', '五', '六', '日']

    LOCATIONS: ['建國', '忠孝', '延平', '大安', '台中', '高雄']

    LOCATIONS_MAPPING: [
        {
            'name': '建國'
            'full_name': '大夏館 建國分部'
            'address': '台北市建國南路二段231號'
        },
        {
            'name': '忠孝'
            'full_name': '忠孝館 忠孝分部'
            'address': '台北市忠孝東路一段41號'
        },
        {
            'name': '延平'
            'full_name': '大新館 延平分部'
            'address': '台北市延平南路127號'
        },
        {
            'name': '大安'
            'full_name': '大安中心'
            'address': '台北市大安區信義路四段1號3樓'
        },
        {
            'name': '台中'
            'full_name': '台中教育中心'
            'address': '台中市西屯區台灣大道三段658號3樓'
        },
        {
            'name': '高雄'
            'full_name': '高雄教育中心'
            'address': '高雄市前金區中正四路215號3樓'
        }
    ]