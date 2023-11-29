//
//  RealmMigration.swift
//  yamTODO
//
//  Created by Jiny on 11/29/23.
//

import RealmSwift
import Foundation

class RealmMigrationManager {

    // 싱글톤 인스턴스 생성
    static let shared = RealmMigrationManager()

    // 마이그레이션 메서드
    func performMigration() {
        let config = Realm.Configuration(
            // 현재 Realm 데이터베이스의 버전을 지정
            schemaVersion: 2,

            // 데이터베이스 업그레이드가 필요한 경우 호출되는 블록
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    self.migrationV2(migration)
                }
            })

        // 새 구성으로 Realm 데이터베이스 열기
        Realm.Configuration.defaultConfiguration = config
        do {
            // 마이그레이션 수행
            _ = try Realm()
        } catch {
            // 마이그레이션 실패 시 처리할 내용
            print("Realm migration failed with error: \(error.localizedDescription)")
        }
    }
    
    private func migrationV2(_ migration: Migration) {
        // 스키마 버전 1에서 2로 마이그레이션 수행
        // 변경된 속성이나 새로운 모델을 추가할 수 있습니다.
        // 기존 객체들에 대한 업데이트
        migration.enumerateObjects(ofType: TaskObject.className()) { oldObject, newObject in
            //'changed' 속성 추가
            newObject?["isChanged"] = false
            newObject?["changedBy"] = oldObject?["createdBy"]
            
            // 만약 이전 객체의 데이터를 기반으로 새로운 속성을 설정해야 한다면, oldObject를 사용할 수 있습니다.
        }
    }
}
