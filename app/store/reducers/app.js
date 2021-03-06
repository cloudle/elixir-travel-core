import * as Actions from '../actions';
import { utils } from 'react-universal-ui';

const initialState = {
  counter: 0,
};

export default utils.appReducer((state = initialState, action) => {
	switch (action.type) {
		case Actions.IncreaseCounter:
			return {...state, counter: state.counter + action.volume};
		default:
			return state;
	}
})