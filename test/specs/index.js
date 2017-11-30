/*
 * LiskHQ/lisk-template
 * Copyright © 2017 Lisk Foundation
 *
 * See the LICENSE file at the top-level directory of this distribution
 * for licensing information.
 *
 * Unless otherwise agreed in a custom licensing agreement with the Lisk Foundation,
 * no part of this software, including this file, may be copied, modified,
 * propagated, or distributed except according to the terms contained in the
 * LICENSE file.
 *
 * Removal or modification of this copyright notice is prohibited.
 *
 */
import * as given from '../steps/given';
import * as when from '../steps/when';
import * as then from '../steps/then';

describe('My first specification', () => {
	describe('Given a given step', () => {
		beforeEach(given.aGivenStep);
		describe('When a when step', () => {
			beforeEach(when.aWhenStep);
			it('Then a then step', then.aThenStep);
		});
	});
});
