//
//  RealmMigration.swift
//  yamTODO
//
//  Created by Jiny on 11/29/23.
//

import RealmSwift
import Foundation

class RealmMigrationManager {
    private let appGroupID = "group.com.jiny.yamTODO"
    
    // Realm Configuration
    private var appGroupRealmConfig: Realm.Configuration? {
        guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appendingPathComponent("default.realm") else {
            return nil
        }
        return Realm.Configuration(fileURL: fileURL, schemaVersion: 5)
    }
    

    // 싱글톤 인스턴스 생성
    static let shared = RealmMigrationManager()
    
    private let nowVersion: UInt64 = 3
    private var oldVersion: UInt64 = 0

    // 마이그레이션 메서드
    func performMigration() {
        print("realm migration \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        let config = Realm.Configuration(
            // 현재 Realm 데이터베이스의 버전을 지정
            schemaVersion: nowVersion,

            // 데이터베이스 업그레이드가 필요한 경우 호출되는 블록
            migrationBlock: { migration, oldSchemaVersion in
                self.oldVersion = oldSchemaVersion
                if oldSchemaVersion < 2 {
                    self.migrationV2(migration)
                }
                if oldSchemaVersion < self.nowVersion {
                    self.migrateRealmToAppGroup()
                }
            })

        // 새 구성으로 Realm 데이터베이스 열기
        Realm.Configuration.defaultConfiguration = config
        // 마이그레이션 수행
        if self.oldVersion < nowVersion {
            do {
                _ = try Realm()
            } catch {
                // 마이그레이션 실패 시 처리할 내용
                print("Realm migration failed with error: \(error.localizedDescription)")
            }
        }else {
            guard let config = self.appGroupRealmConfig else {
                print("Error: DB 없음")
                return
            }
            do {
                _ = try Realm(configuration: config)
            } catch {
                // 마이그레이션 실패 시 처리할 내용
                print("Realm migration failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func migrationV2(_ migration: Migration) {
        print("realm migration2 \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        // 스키마 버전 1에서 2로 마이그레이션 수행
        // 변경된 속성이나 새로운 모델을 추가할 수 있습니다.
        // 기존 객체들에 대한 업데이트
        migration.enumerateObjects(ofType: TaskObject.className()) { oldObject, newObject in
            //'changed' 속성 추가
            newObject?["isChanged"] = false
            newObject?["changedBy"] = oldObject?["createdBy"]
            newObject?["isFixed"] = false
            
            // 만약 이전 객체의 데이터를 기반으로 새로운 속성을 설정해야 한다면, oldObject를 사용할 수 있습니다.
        }
    }
    
    func migrateRealmToAppGroup() {
        print("realm migration3 \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL
        let appGroupPath = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.jiny.yamTODO")?
            .appendingPathComponent("default.realm")
        
        guard let defaultPath = defaultPath, let appGroupPath = appGroupPath else {
            print("Failed to get Realm file paths")
            return
        }

        // App Group 경로에 파일이 이미 존재하는 경우 이동하지 않음
        if FileManager.default.fileExists(atPath: appGroupPath.path) {
            print("Realm already migrated to App Group")
            return
        }

        // 기본 Realm 파일이 존재하는 경우 이동
        if FileManager.default.fileExists(atPath: defaultPath.path) {
            do {
                try FileManager.default.copyItem(at: defaultPath, to: appGroupPath)
                print("Realm file migrated to App Group")
            } catch {
                print("Failed to migrate Realm file: \(error.localizedDescription)")
            }
        } else {
            print("No existing Realm file to migrate")
        }
    }
}
