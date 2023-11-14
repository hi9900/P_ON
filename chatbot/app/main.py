
from kafka.connect_to_kafka import kafka_producer
from model.make_schedule import UserMessage_to_cal
# # from model.find_schedule import convert_date

# import json
# from datetime import datetime


# # 일정 생성
from fastapi import FastAPI, Header, Request
from typing import Union

app = FastAPI()


@app.post("/chatbot")
async def create_calendar(
    request: Request,
    userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id"),
):
    json_data = await request.json()
    text = json_data.get("content", "")

    res = UserMessage_to_cal(text)

    topic_message = {
        'userId' : userId,
        'cal' : res
    }
    kafka_producer(topic_message)

    return {"res" : topic_message}


# # 일정 조회
# @app.get("/chatbot")
# async def root(
#     userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id"),
#     text: str = Body(...)
#     ):

#     target_date = convert_date(text)

#     # json 파일 열기
#     with open('data/cal.json', 'r') as f:
#         data = json.load(f)

#     # userID가 1이고 calendar_start_date가 target_date와 일치하는 객체 찾기
#     result = []
#     for item in data:
#         if item['userID'] == userId and item['calendar_start_date'] == target_date:
#             result.append(item)


#     return {"result": result}


# 일정 조회
@app.get("/")
async def root(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):
    context = {
        'userId' : userId,
        'message' : 'hi'
    }
    return context