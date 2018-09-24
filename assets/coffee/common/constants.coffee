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
        'device': 'https://sceapi.sce.pccu.edu.tw/SceAppApi'
        'device_ssl': 'https://sceapi.sce.pccu.edu.tw/SceAppApi'
        'atm_browser': 'http://localhost:8100/AtmWebApi'
        'atm': 'https://scepayment.sce.pccu.edu.tw/AtmWebApi'
        'creditcard_browser': 'http://localhost:8100/CCardWebAPI'
        'creditcard': 'https://scepayment.sce.pccu.edu.tw/CCardWebAPI'
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

    FILTER_OFF_LOCATIONS: [ '大安', '大安中心' ]

    WEEKDAYS: ['一', '二', '三', '四', '五', '六', '日']
    WEEKDAYS_MAPPING: [
        {
            'title': '週一至週六'
            'weekdays' : ['一', '二', '三', '四', '五', '六']
        },
        {
            'title': '週一至週五'
            'weekdays' : ['一', '二', '三', '四', '五']
        },
        {
            'title': '週六'
            'weekdays' : ['六']
        },
        {
            'title': '週日'
            'weekdays' : ['日']
        }
    ]

    LOCATIONS: ['建國', '忠孝', '延平', '大安', '台中', '高雄']

    LOCATIONS_MAPPING: [
        {
            'location_name': '建國本部大夏館'
            'short_name': '建國'
            'full_name': '大夏館 建國分部'
            'address': '台北市建國南路二段231號'
            'html_name1': '建國本部'
            'html_name2': '大夏館'
            'bgcolor': '#669ccc'
            'latlng':
                'n': 25.026133
                'e': 121.538099
        },
        {
            'location_name': '忠孝分部'
            'short_name': '忠孝'
            'full_name': '忠孝館 忠孝分部'
            'address': '台北市忠孝東路一段41號'
            'html_name1': '忠孝'
            'html_name2': '分部'
            'bgcolor': '#cf4b94'
            'latlng':
                'n': 25.044707
                'e': 121.525787
        },
        {
            'location_name': '延平分部'
            'short_name': '延平'
            'full_name': '大新館 延平分部'
            'address': '台北市延平南路127號'
            'html_name1': '延平'
            'html_name2': '分部'
            'bgcolor': '#f9b233'
            'latlng':
                'n': 25.038641
                'e': 121.508613
        },
        {
            'location_name': '大安中心'
            'short_name': '大安'
            'full_name': '大安中心'
            'address': '台北市大安區信義路四段1號3樓'
            'html_name1': '大安'
            'html_name2': '中心'
            'bgcolor': '#3ebbcf'
            'latlng':
                'n': 25.033828
                'e': 121.544288
        },
        {
            'location_name': '台中教育中心'
            'short_name': '台中'
            'full_name': '台中教育中心'
            'address': '台中市西屯區台灣大道三段658號3樓'
            'html_name1': '台中'
            'html_name2': '教育中心'
            'bgcolor': '#e46272'
            'latlng':
                'n': 24.170737
                'e': 120.638142
        },
        {
            'location_name': '高雄教育中心'
            'short_name': '高雄'
            'full_name': '高雄教育中心'
            'address': '高雄市前金區中正四路215號3樓'
            'html_name1': '高雄'
            'html_name2': '教育中心'
            'bgcolor': '#0097cd'
            'latlng':
                'n': 22.628311
                'e': 120.293095
        }
    ]

    DEVICEMODEL_MAPPING: [
        { 'model': 'iphone3,1', 'deviceName': 'iphone4' }
        { 'model': 'iphone3,2', 'deviceName': 'iphone4' }
        { 'model': 'iphone3,3', 'deviceName': 'iphone4' }
        { 'model': 'iphone4,1', 'deviceName': 'iphone4s' }
        { 'model': 'iphone5,1', 'deviceName': 'iphone5' }
        { 'model': 'iphone5,2', 'deviceName': 'iphone5' }
        { 'model': 'iphone5,3', 'deviceName': 'iphone5c' }
        { 'model': 'iphone5,4', 'deviceName': 'iphone5c' }
        { 'model': 'iphone6,1', 'deviceName': 'iphone5s' }
        { 'model': 'iphone6,2', 'deviceName': 'iphone5s' }
        { 'model': 'iphone7,2', 'deviceName': 'iphone6' }
        { 'model': 'iphone7,1', 'deviceName': 'iphone6-plus' }
        { 'model': 'iphone8,1', 'deviceName': 'iphone6s' }
        { 'model': 'iphone8,2', 'deviceName': 'iphone6s-plus' }
        { 'model': 'iphone8,4', 'deviceName': 'iphone-se' }
        { 'model': 'iphone9,1', 'deviceName': 'iphone7' }
        { 'model': 'iphone9,3', 'deviceName': 'iphone7' }
        { 'model': 'iphone9,2', 'deviceName': 'iphone7-plus' }
        { 'model': 'iphone9,4', 'deviceName': 'iphone7-plus' }
    ]
