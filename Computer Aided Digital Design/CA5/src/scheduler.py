from abc import ABC, abstractmethod
from .dfg_creator import BaseNode, OperatorNode, OP_TYPES
from typing import List

class ScheduledNodeInfo:
    def __init__(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        self.node = node
        self.scheduled_time = scheduled_time
        self.resource_num = resource_num


class ListScheduler(ABC):
    def __init__(self, dfg_root : BaseNode, numof_reources : dict):
        self.root = dfg_root
        if numof_reources is None:
            self.numof_resources = {op: 1 for op in OP_TYPES}
        else:
            self.numof_resources = numof_reources

        self.scheduled_nodes_info : List[ScheduledNodeInfo] = []


    '''
        For a node, records its execution cycle and index of the resource to be executed on.
    '''
    def record_scheduled_node(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        recorded_info = ScheduledNodeInfo(node=node, scheduled_time=scheduled_time, resource_num=resource_num)
        self.scheduled_nodes_info.append(recorded_info)


    '''
        Returns the list of all ScheduledNodeInfos sorted by their node id.
    '''
    def get_scheduling_info(self) -> List[ScheduledNodeInfo]:
        return sorted(self.scheduled_nodes_info, key = lambda node_info: node_info.node.id)


    '''
        Returns a list of nodes that are ready to execute at the time.
        Operands of these nodes are either an IdentifierNode or the result of an already executed OperatorNode.
    '''
    @abstractmethod
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass


    '''
        Based on the algorithm, it selects nodes from frontier to be executed on the currently available resources.
        Frontier is the output of find_candidate_nodes.
    '''
    @abstractmethod
    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        pass


    '''
        Performes the process of scheduling.
        It repeatedly selects some nodes from frontier to be executed at the time and records their scheduling information until there are no more nodes. 
    '''
    @abstractmethod
    def schedule(self) -> None:
        pass



class MinLatencyScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.all_operators = self._get_all_operators()

    def _get_all_operators(self) -> List[OperatorNode]:
        nodes = []
        visited = set()
        def traverse(node):
            if node is None: return
            if node.id in visited: return
            visited.add(node.id)
            
            if isinstance(node, OperatorNode):
                nodes.append(node)
                for op in node.operands:
                    traverse(op)
        
        traverse(self.root)
        return nodes

    def find_candidate_nodes(self) -> List[OperatorNode]:
        scheduled_ids = {info.node.id for info in self.scheduled_nodes_info}
        candidates = []
        
        for node in self.all_operators:
            if node.id in scheduled_ids:
                continue
            
            is_ready = True
            for op in node.operands:
                if isinstance(op, OperatorNode) and op.id not in scheduled_ids:
                    is_ready = False
                    break
            
            if is_ready:
                candidates.append(node)
                
        return candidates

    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        frontier.sort(key=lambda x: x.depth, reverse=True)
        
        selected = []
        resources_available = self.numof_resources.copy()
        
        for node in frontier:
            if resources_available.get(node.op_type, 0) > 0:
                selected.append(node)
                resources_available[node.op_type] -= 1
                
        return selected

    def schedule(self) -> None:
        current_time = 1
        total_ops = len(self.all_operators)
        
        while len(self.scheduled_nodes_info) < total_ops:
            candidates = self.find_candidate_nodes()
            
            if not candidates:
                break 
                
            selected_nodes = self.select_from_frontier(candidates)
            
            resource_usage_count = {}
            
            for node in selected_nodes:
                r_type = node.op_type
                r_num = resource_usage_count.get(r_type, 0) + 1
                resource_usage_count[r_type] = r_num
                
                self.record_scheduled_node(node, current_time, r_num)
            
            current_time += 1

    

    
class MinResourceScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict, max_time : int):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.max_time = max_time
        self.all_operators = self._get_all_operators()
        self.latest_time = self.find_latest_times()

    def _get_all_operators(self) -> List[OperatorNode]:
        nodes = []
        visited = set()
        def traverse(node):
            if node is None: return
            if node.id in visited: return
            visited.add(node.id)
            
            if isinstance(node, OperatorNode):
                nodes.append(node)
                for op in node.operands:
                    traverse(op)
        
        traverse(self.root)
        return nodes

    '''
        Assigns the latest possible time for each node to be executed.
        It's used on Minimum-Resource, Latency-Constrained algorithm.
    '''
    def find_latest_times(self) -> dict:
        latest_times = {}
        for op in self.all_operators:
            latest_times[op.id] = float('inf')
            
        def set_alap(node, time):
            if not isinstance(node, OperatorNode):
                return
            
            if time < latest_times[node.id]:
                latest_times[node.id] = time
                for op in node.operands:
                    set_alap(op, time - 1)

        set_alap(self.root, self.max_time)
        return latest_times
   
    def find_candidate_nodes(self) -> List[OperatorNode]:
        scheduled_ids = {info.node.id for info in self.scheduled_nodes_info}
        candidates = []
        
        for node in self.all_operators:
            if node.id in scheduled_ids:
                continue
            
            is_ready = True
            for op in node.operands:
                if isinstance(op, OperatorNode) and op.id not in scheduled_ids:
                    is_ready = False
                    break
            
            if is_ready:
                candidates.append(node)
                
        return candidates

    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        frontier.sort(key=lambda x: self.latest_time.get(x.id, float('inf')))
        
        selected = []
        resources_available = self.numof_resources.copy()
        
        for node in frontier:
            if resources_available.get(node.op_type, 0) > 0:
                selected.append(node)
                resources_available[node.op_type] -= 1
                
        return selected

    def schedule(self) -> None:
        current_time = 1
        total_ops = len(self.all_operators)
        
        while len(self.scheduled_nodes_info) < total_ops:
            candidates = self.find_candidate_nodes()
            
            if not candidates:
                break 
                
            selected_nodes = self.select_from_frontier(candidates)
            
            resource_usage_count = {}
            for node in selected_nodes:
                r_type = node.op_type
                r_num = resource_usage_count.get(r_type, 0) + 1
                resource_usage_count[r_type] = r_num
                
                self.record_scheduled_node(node, current_time, r_num)
            
            current_time += 1