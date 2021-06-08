//
//  AnyTargetActionWrapper.swift
//  Themer
//
//  Created by Serge Bouts on 5/28/19
//  Copyright © Serge Bouts 2019
//  MIT license, see LICENSE file for details
//
// A type-erased *target-action* wrapper, which is how *target-actions*
// (theme handlers) are held.
struct AnyTargetActionWrapper<Theme: ThemeProtocol>: TargetAction {
    private let _applyTheme: (Theme) -> ()

    init<Target: AnyObject>(target: Target, action: @escaping (Target) -> (Theme) -> ()) {
        self._applyTheme = { [weak target] theme in
            guard let target = target else { return; }
            action(target)(theme)
        }
    }

    func applyTheme(_ theme: Theme) -> () {
        _applyTheme(theme)
    }
}
