from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
import requests
import cx_Oracle
import xml.etree.ElementTree as ET
import re

app = Flask(__name__)

# Oracle DB 연결 정보 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://blue:blue@192.168.0.44:1521/xe'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


# DB 모델 정의
class ApiData(db.Model):
    __tablename__ = 'api_data'

    id = db.Column(db.Integer, primary_key=True)
    prce_reg_ymd = db.Column(db.String(100))  # prce_reg_ymd
    pdlt_code = db.Column(db.String(100))  # pdlt_code
    pdlt_nm = db.Column(db.String(100))  # pdlt_nm
    spcs_code = db.Column(db.String(100))  # spcs_code
    spcs_nm = db.Column(db.String(100))  # spcs_nm
    pdlt_ctg_code = db.Column(db.String(100))  # pdlt_ctg_code
    avrg_prce = db.Column(db.String(100))  # avrg_prce
    wsrt_exmn_se_code = db.Column(db.String(100))  # wsrt_exmn_se_code
    grad_code = db.Column(db.String(100))  # grad_code
    grad_nm = db.Column(db.String(100))  # grad_nm
    dsbn_step_acto_unit_nm = db.Column(db.String(100))  # dsbn_step_acto_unit_nm
    dsbn_step_acto_wt = db.Column(db.String(100))  # dsbn_step_acto_wt
    tdy_lwet_prce = db.Column(db.String(100))  # tdy_lwet_prce
    tdy_max_prce = db.Column(db.String(100))  # tdy_max_prce
    etl_ldg_dt = db.Column(db.String(100))  # etl_ldg_dt

    def __init__(self, prce_reg_ymd, pdlt_code, pdlt_nm, spcs_code, spcs_nm, pdlt_ctg_code,
                 avrg_prce, wsrt_exmn_se_code, grad_code, grad_nm, dsbn_step_acto_unit_nm,
                 dsbn_step_acto_wt, tdy_lwet_prce, tdy_max_prce, etl_ldg_dt):
        self.prce_reg_ymd = prce_reg_ymd
        self.pdlt_code = pdlt_code
        self.pdlt_nm = pdlt_nm
        self.spcs_code = spcs_code
        self.spcs_nm = spcs_nm
        self.pdlt_ctg_code = pdlt_ctg_code
        self.avrg_prce = avrg_prce
        self.wsrt_exmn_se_code = wsrt_exmn_se_code
        self.grad_code = grad_code
        self.grad_nm = grad_nm
        self.dsbn_step_acto_unit_nm = dsbn_step_acto_unit_nm
        self.dsbn_step_acto_wt = dsbn_step_acto_wt
        self.tdy_lwet_prce = tdy_lwet_prce
        self.tdy_max_prce = tdy_max_prce
        self.etl_ldg_dt = etl_ldg_dt


# API 데이터 호출 및 DB 저장 함수
def fetch_and_save_api_data(api_url):
    # API 호출
    response = requests.get(api_url)
    if response.status_code == 200:
        # XML 파싱
        root = ET.fromstring(response.text)

        # XML 내의 데이터 추출
        for item in root.findall('.//item'):
            # p_regday 값 추출 후 '20241202' 형식으로 변환
            p_regday = item.find('p_regday').text
            formatted_regday = p_regday.replace('-', '')  # '2024-12-02' -> '20241202'

            # 데이터 항목 추출
            pdlt_code = item.find('item_code').text if item.find('item_code') is not None else ''
            pdlt_nm = item.find('item_name').text if item.find('item_name') is not None else ''
            spcs_code = item.find('item_code').text if item.find('item_code') is not None else ''
            spcs_nm = item.find('kind_name').text if item.find('kind_name') is not None else ''
            pdlt_ctg_code = item.find('p_category_code').text if item.find('p_category_code') is not None else ''
            avrg_prce = item.find('dpr1').text if item.find('dpr1') is not None else ''
            wsrt_exmn_se_code = item.find('p_product_cls_code').text if item.find(
                'p_product_cls_code') is not None else ''
            grad_code = item.find('rank_code').text if item.find('rank_code') is not None else ''
            grad_nm = item.find('rank').text if item.find('rank') is not None else ''

            # dsbn_step_acto_unit_nm과 dsbn_step_acto_wt 처리
            unit = item.find('unit').text if item.find('unit') is not None else ''
            dsbn_step_acto_unit_nm = re.sub(r'\d+|\(|\)', '', unit).strip()  # 숫자와 () 제외
            dsbn_step_acto_wt = ''.join(re.findall(r'\d+', unit))  # 숫자만 추출

            # pdlt_ctg_nm과 exmn_se_nm은 항상 '채소류'와 '도매'로 설정
            pdlt_ctg_nm = '채소류'
            exmn_se_nm = '도매'

            # DB에 저장
            new_data = ApiData(prce_reg_ymd=formatted_regday, pdlt_code=pdlt_code, pdlt_nm=pdlt_nm,
                               spcs_code=spcs_code, spcs_nm=spcs_nm, pdlt_ctg_code=pdlt_ctg_code,
                               avrg_prce=avrg_prce, wsrt_exmn_se_code=wsrt_exmn_se_code, grad_code=grad_code,
                               grad_nm=grad_nm, dsbn_step_acto_unit_nm=dsbn_step_acto_unit_nm,
                               dsbn_step_acto_wt=dsbn_step_acto_wt, tdy_lwet_prce=None, tdy_max_prce=None,
                               etl_ldg_dt=None)

            db.session.add(new_data)

        db.session.commit()  # 변경사항 DB에 커밋
        print("Data successfully saved to the database.")
    else:
        print("Failed to fetch data from the API.")


# Flask 엔드포인트
@app.route('/fetch-api-data', methods=['GET'])
def fetch_api_data():
    api_url = ('https://www.kamis.or.kr/service/price/xml.do?action=dailyPriceByCategoryList'
               '&p_product_cls_code=02&p_regday=2024-12-02&p_convert_kg_yn=N&p_item_category_code=200'
               '&p_cert_key=21980a3f-3bba-4994-aa23-099eb549518c&p_cert_id=5072&p_returntype=xml')
    fetch_and_save_api_data(api_url)
    return jsonify({"message": "데이터 가져오기 및 저장 완료!"})


if __name__ == '__main__':
    app.run(debug=True)