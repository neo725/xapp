module.exports =
    # on mobile
    #API_URL: 'http://test.sce.pccu.edu.tw/SceAppApi'
    # dev mode (chrome)
    #API_URL: 'http://localhost:8100/SceAppApi'
    API_URL: {
        'browser': 'http://localhost:8100/SceAppApi'
        'device': 'http://test.sce.pccu.edu.tw/SceAppApi'
        'atm': 'http://140.137.200.233/AtmWebApi'
        'creditcard': 'http://140.137.200.233/CCardWebAPI'
    }

    DEFAULT_LOCALE: 'zh-Hant'

    WEEKDAYS: ['一', '二', '三', '四', '五', '六', '日']

    LOCATIONS: ['建國', '忠孝', '延平', '大安', '台中', '高雄']

    LOCATIONS_MAPPING: [
        {
            'name': '建國'
            'full_name': '大夏館 建國分部'
        },
        {
            'name': '忠孝'
            'full_name': '忠孝館 忠孝分部'
        },
        {
            'name': '延平'
            'full_name': '大新館 延平分部'
        },
        {
            'name': '大安'
            'full_name': '大安中心'
        },
        {
            'name': '台中'
            'full_name': '台中教育中心'
        },
        {
            'name': '高雄'
            'full_name': '高雄教育中心'
        }
    ]