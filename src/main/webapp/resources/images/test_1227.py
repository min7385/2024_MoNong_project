import cx_Oracle
import os

# 오라클 DB 연결 정보
conn = cx_Oracle.connect('blue', 'blue', '192.168.0.44:1521/xe')
cursor = conn.cursor()

folder_path = './vegetables'  # 로컬 경로
db_path_prefix = 'images/vegetables/'  # DB에 삽입할 경로 접두어

# 폴더 경로 확인
if not os.path.isdir(folder_path):
    raise FileNotFoundError(f"지정된 경로가 존재하지 않습니다: {folder_path}")

# 유효한 이미지 파일 확장자
valid_extensions = ('.jpg', '.jpeg', '.png')

# 이미지 삽입 작업
try:
    inserted_count = 0  # 삽입된 이미지 수

    for filename in os.listdir(folder_path):
        if filename.lower().endswith(valid_extensions):  # 확장자 확인
            pdlt_nm = os.path.splitext(filename)[0]  # 확장자 제거
            db_path = os.path.join(db_path_prefix, filename).replace("\\", "/")  # DB 경로 설정

            # 데이터 삽입
            cursor.execute("""
                INSERT INTO product_images2 (product_images_id, pdlt_nm, pdlt_path)
                VALUES (product_images2_seq.NEXTVAL, :pdlt_nm, :pdlt_path)
            """, pdlt_nm=pdlt_nm, pdlt_path=db_path)

            inserted_count += 1
            print(f"[성공] {filename} 이미지 경로 삽입 완료: {db_path}")

    # DB에 변경 사항 저장
    conn.commit()

    print(f"총 {inserted_count}개의 이미지가 성공적으로 삽입되었습니다.")

except Exception as e:
    print(f"[오류] 작업 중 예외 발생: {e}")
    conn.rollback()

finally:
    # DB 연결 닫기
    cursor.close()
    conn.close()